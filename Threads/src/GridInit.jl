function LCG_random_double(seed::UInt64)

    m::UInt64 = 9_223_372_036_854_775_808 # 2^63
    a::UInt64 = 2_806_196_910_506_780_709
    c::UInt64 = 1
    new_seed::UInt64 = (a * seed + c) % m
    new_seed_d::Float64 = Float64(new_seed) / Float64(m)
    return new_seed, new_seed_d
end

function grid_init_do_not_profile(inputs::Inputs, mype::Int32)::SimulationData

    ## Structure to hold all allocated simuluation data arrays
    simulation_data = SimulationData()

    ## Keep track of how much data we're allocating
    nbytes::UInt64 = 0

    ## Set the initial seed value
    seed::UInt64 = 42

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
    resize!(simulation_data.nuclide_grid, simulation_data.length_nuclide_grid)

    nbytes += size(simulation_data.nuclide_grid)[1] * sizeof(NuclideGridPoint)
    println("nbytes: ", nbytes)

    for i = 1:simulation_data.length_nuclide_grid
        #println("i: ", i)
        #simulation_data.nuclide_grid[i].energy = 0
    end




    return simulation_data

end
