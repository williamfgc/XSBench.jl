function LCG_random_double(seed::UInt64)::Tuple{UInt64,Float64}

    m::UInt64 = 9_223_372_036_854_775_808 # 2^63
    a::UInt64 = 2_806_196_910_506_780_709
    c::UInt64 = 1
    new_seed::UInt64 = (a * seed + c) % m
    new_seed_d::Float64 = Float64(new_seed) / Float64(m)
    return new_seed, new_seed_d
end

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
    ## of a flattened 2D array that hold all the information we need to define
    ## the cross sections for all isotopes in the simulation. 
    ## The grid is composed of "NuclideGridPoint" structures, which hold the
    ## energy level of the grid point and all associated XS data at that level.
    ## An array of structures (AOS) is used instead of
    ## a structure of arrays, as the grid points themselves are accessed in 
    ## a random order, but all cross section interaction channels and the
    ## energy level are read whenever the gridpoint is accessed, meaning the
    ## AOS is more cache efficient.

    ## Allocate Nuclide Grid
    simulation_data.length_nuclide_grid = inputs.n_isotopes * inputs.n_gridpoints
    simulation_data.nuclide_grid =
        Array{NuclideGridPoint}(undef, inputs.n_gridpoints, inputs.n_isotopes)

    nbytes += simulation_data.length_nuclide_grid * sizeof(NuclideGridPoint)
    println("nbytes: ", nbytes)

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
        end
    end

    return simulation_data

end
