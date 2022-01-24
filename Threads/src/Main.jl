
import MPI
import XSBenchThreads


function main(args)::Int32

    # =====================================================================
    # Initialization & Command Line Read-In
    # =====================================================================
    # local const are deprecated see https://github.com/JuliaLang/julia/pull/23259
    # variables must always be initialized

    version::Int32 = Int32(20)
    omp_start::Float64 = Float64(0.0)
    omp_end::Float64 = Float64(0.0)
    verification::Int64 = Int64(0)

    MPI.Init()

    nprocs::Int32 = MPI.Comm_size(MPI.COMM_WORLD)
    mype::Int32 = MPI.Comm_rank(MPI.COMM_WORLD)

    # Process CLI Fields -- store in "Inputs" structure
    inputs::XSBenchThreads.Inputs = XSBenchThreads.read_CLI(args)

    if mype == 0
        # TODO print_inputs( in, nprocs, version )
    end

    # // =====================================================================
    # // Prepare Nuclide Energy Grids, Unionized Energy Grid, & Material Data
    # // This is not reflective of a real Monte Carlo simulation workload,
    # // therefore, do not profile this region!
    # // =====================================================================

    simulation_data::XSBenchThreads.SimulationData = XSBenchThreads.SimulationData()

    # If read from file mode is selected, skip initialization and load
    # all simulation data structures from file instead
    if inputs.binary_mode == "read"
        # simulation_data = binary_read(in)
    else
        simulation_data = XSBenchThreads.grid_init_do_not_profile(inputs, mype)
    end

    #  If writing from file mode is selected, write all simulation data
    # structures to file
    if inputs.binary_mode == "write" && mype == 0
        binary_write(inputs, simulation_data)
    end

    # =====================================================================
    # Cross Section (XS) Parallel Lookup Simulation
    # This is the section that should be profiled, as it reflects a 
    # realistic continuous energy Monte Carlo macroscopic cross section
    # lookup kernel.
    # =====================================================================

    ## Start Simulation Timer
    @time begin

        sleep(1)

        ## Run simulation
        if inputs.simulation_method == "event_based"

            if inputs.kernel_id == 0
                # run_event_based_simulation
            end

        elseif inputs.simulation_method == "history_based"

        end

    end

    MPI.Finalize()

    return 0
end

# main(ARGS)
