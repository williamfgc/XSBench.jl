module XSBenchThreads

# struct
export Inputs
# functions
export main, read_CLI

import MPI

HISTORY_BASED = 1

mutable struct Inputs
    nthreads::Int32
    n_isotopes::Int64
    n_gridpoints::Int64
    lookups::Int32
    HM::String
    grid_type::Int32
    hash_bins::Int32
    particles::Int32
    simulation_method::Int32
    binary_mode::Int32
    kernel_id::Int32
end

include("io.jl")

function mainImpl(args)

    # println(args)

    # =====================================================================
    # Initialization & Command Line Read-In
    # =====================================================================
    # local const are deprecated see https://github.com/JuliaLang/julia/pull/23259
    # variables must always be initialized
    version::Int32 = 20
    omp_start::Float64 = 0.0
    omp_end::Float64 = 0.0
    verification::Int64 = 0

    MPI.Init()
    stat::MPI.Status
    nprocs::Int32 = MPI.Comm_size(MPI.COMM_WORLD)
    mype::Int32 = MPI.Comm_rank(MPI.COMM_WORLD)

    # Process CLI Fields -- store in "Inputs" structure
    in::Inputs = XSBenchThreads.read_CLI(args)

    # if mype == 0
    # print_inputs( in, nprocs, version )

    # =====================================================================
    # Cross Section (XS) Parallel Lookup Simulation
    # This is the section that should be profiled, as it reflects a 
    # realistic continuous energy Monte Carlo macroscopic cross section
    # lookup kernel.
    # =====================================================================

    ## Start Simulation Timer
    # omp_start = get_time();

    ## Run simulation
    # if in.simulation_method == EVENT_BASED 
    # 	if( in.kernel_id == 0 )
    # 		verification = run_event_based_simulation(in, SD, mype);
    # 	else if( in.kernel_id == 1 )
    # 		verification = run_event_based_simulation_optimization_1(in, SD, mype);
    # 	else
    # 	{
    # 		printf("Error: No kernel ID %d found!\n", in.kernel_id);
    # 		exit(1);
    # 	}
    # else
    # 	verification = run_history_based_simulation(in, SD, mype);

    # if( mype == 0)	
    # {	
    # 	printf("\n" );
    # 	printf("Simulation complete.\n" );
    # }


    MPI.Finalize()
end

end


