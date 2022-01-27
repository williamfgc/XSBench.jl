

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

    ## Initialize Nuclide Grid
    simulation_data.length_nuclide_grid = inputs.n_isotopes * inputs.n_gridpoints

    resize!(simulation_data.nuclide_grid, simulation_data.length_nuclide_grid)

    nbytes += size(simulation_data.nuclide_grid)[1] * sizeof(NuclideGridPoint)
    println("nbytes: ", nbytes)

    return simulation_data

end
