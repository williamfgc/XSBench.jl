
import Printf

include("Materials.jl")

function grid_init_do_not_profile(inputs::Inputs, mype::Int32)::SimulationData

    ## Structure to hold all allocated simulution data arrays
    simulation_data = SimulationData()

    ## Keep track of how much data we're allocating
    nbytes::UInt64 = 0

    ##############################
    ## Initialize Nuclide Grids
    ##############################

    if mype == 0
        println("Initializing nuclide grids...")
    end

    ## First, we need to initialize our nuclide grid. This comes in the form
    ## of a 2D array that hold all the information we need to define
    ## the cross sections for all isotopes in the simulation. 
    ## The grid is composed of "NuclideGridPoint" structures, which hold the
    ## energy level of the grid point and all associated XS data at that level.
    ## An array of structures (AOS) is used instead of
    ## a structure of arrays, as the grid points themselves are accessed in 
    ## a random order, but all cross section interaction channels and the
    ## energy level are read whenever the gridpoint is accessed, meaning the
    ## AOS is more cache efficient.

    ## Allocate Nuclide Grid
    #inputs.n_isotopes = 2 #temp
    #inputs.n_gridpoints = 4 #temp

    simulation_data.length_nuclide_grid =
        inputs.n_isotopes * inputs.n_gridpoints
    simulation_data.nuclide_grid =
        Array{NuclideGridPoint}(undef, inputs.n_gridpoints, inputs.n_isotopes)

    nbytes += simulation_data.length_nuclide_grid * sizeof(NuclideGridPoint)

    ## Set the initial seed value
    seed::UInt64 = 42

    for i = 1:inputs.n_isotopes
        for j = 1:inputs.n_gridpoints

            # create local struct
            # nice because type alignment is known and no need to repeat
            grid_point = NuclideGridPoint()

            seed, grid_point.energy = LCG_random_double(seed)
            seed, grid_point.total_xs = LCG_random_double(seed)
            seed, grid_point.elastic_xs = LCG_random_double(seed)
            seed, grid_point.absorption_xs = LCG_random_double(seed)
            seed, grid_point.fission_xs = LCG_random_double(seed)
            seed, grid_point.nu_fission_xs = LCG_random_double(seed)

            simulation_data.nuclide_grid[j, i] = grid_point

            # println("j: ", j, " i: ", i, " ", grid_point.energy)
        end
    end

    # Sort so that each nuclide has data stored in ascending energy order.
    sort!(simulation_data.nuclide_grid, dims = 1, by = v -> v.energy)

    # println("Sorted by energy: ")
    # for i = 1:inputs.n_isotopes
    #     for j = 1:inputs.n_gridpoints
    #         println("j: ", j, " i: ", i, " ", simulation_data.nuclide_grid[j, i])
    #     end
    #     println("")
    # end

    ####################################
    ## Initialize Acceleration Structure
    ####################################  

    if inputs.grid_type == "nuclide"
        simulation_data.length_unionized_energy_array = 0
        simulation_data.length_index_grid = 0
    end

    if inputs.grid_type == "unionized"
        if mype == 0
            println("Initializing unionized grid...")
        end

        simulation_data.length_unionized_energy_array =
            inputs.n_gridpoints * inputs.n_isotopes
        simulation_data.unionized_energy_array =
            Array{Float64}(undef, inputs.n_gridpoints, inputs.n_isotopes)

        nbytes +=
            simulation_data.length_unionized_energy_array * sizeof(Float64)

        # Copy energy data over from the nuclide energy grid
        for i = 1:inputs.n_isotopes
            for j = 1:inputs.n_gridpoints
                simulation_data.unionized_energy_array[j, i] =
                    simulation_data.nuclide_grid[j, i].energy
            end
        end

        # Sort unionized energy array
        sort!(reshape(simulation_data.unionized_energy_array, :))

        # Allocate space to hold the acceleration grid indices
        simulation_data.index_grid = Array{Int32}(
            undef,
            inputs.n_isotopes,
            inputs.n_gridpoints,
            inputs.n_isotopes,
        )

        simulation_data.length_index_grid =
            simulation_data.length_unionized_energy_array * inputs.n_isotopes
        nbytes += simulation_data.length_index_grid * sizeof(Int32)

        # Generates the double indexing grid
        # one initialized array (1 is the minimum index in Julia)
        # should this information be a Tuple?
        idx_low::Array{Int32,1} = ones(Int32, inputs.n_isotopes)
        energy_high::Array{Float64,1} =
            Array{Float64,1}(undef, inputs.n_isotopes)

        # initialize energy_high with the 2nd element for each isotope
        for i = 1:inputs.n_isotopes
            energy_high[i] = simulation_data.nuclide_grid[2, i].energy
        end

        for i = 1:inputs.n_isotopes
            for j = 1:inputs.n_gridpoints
                # get local unionized_energy from aboslute sorted array
                unionized_energy::Float64 =
                    simulation_data.unionized_energy_array[j, i]

                for k = 1:inputs.n_isotopes

                    if unionized_energy < energy_high[k]
                        simulation_data.index_grid[k, j, i] = idx_low[k]
                    elseif idx_low[k] == inputs.n_gridpoints - 1
                        simulation_data.index_grid[k, j, i] = idx_low[k]
                    else
                        idx_low[k] += 1
                        simulation_data.index_grid[k, j, i] = idx_low[k]
                        energy_high[k] =
                            simulation_data.nuclide_grid[idx_low[k]+1, k].energy
                    end
                end
            end
        end

        # here idx_low and energy_high should be collected

    end

    println("nbytes: ", nbytes)

    ## TODO: pending HASH grid_type

    ################################################
    ## Initialize Materials and Concentrations
    ################################################

    if mype == 0
        println("Intializing material data...\n")
    end

    # Set the number of nuclides for each material
    simulation_data.num_nucs = load_num_nucs(inputs.n_isotopes)
    #     Initialize the 2D grid of material data. The grid holds
    #    a list of nuclide indices for each of the 12 material types. The
    #    grid is allocated as a full square grid, even though not all
    #    materials have the same number of nuclides.
    simulation_data.max_num_nucs, simulation_data.mats =
        load_mats(simulation_data.num_nucs, inputs.n_isotopes)
    #.length_mats = SD.length_num_nucs * SD.max_num_nucs;

    #    Initialize the 2D grid of nuclide concentration data. The grid
    #    holds a list of nuclide concentrations for each of the 12 material types.
    #    The grid is allocated as a full square grid, even though not all materials
    #    have the same number of nuclides.
    simulation_data.concs =
        load_concs(simulation_data.num_nucs, simulation_data.max_num_nucs)

    if mype == 0
        Printf.@printf(
            "Initialization complete. Allocated %.3f MB of data\n",
            nbytes / 1024.0 / 1024.0,
        )
    end

    return simulation_data

end
