
function logo(version::Int32)

    border_print_()
    print(
        "                   __   __ ___________                 _                        \n" *
        "                   \\ \\ / ##  ___| ___ \\               | |                       \n" *
        "                    \\ V / \\ `--.| |_/ / ___ _ __   ___| |__                     \n" *
        "                    /   \\  `--. \\ ___ \\/ _ \\ '_ \\ / __| '_ \\                    \n" *
        "                   / /^\\ \\/\\__/ / |_/ /  __/ | | | (__| | | |                   \n" *
        "                   \\/   \\/\\____/\\____/ \\___|_| |_|\\___|_| |_|                   \n\n",
    )
    border_print_()
    center_print_("Developed at Argonne National Laboratory", 79)
    center_print_("XSBench.jl is developed at Oak Ridge National Laboratory", 79)

    v::String = string("Version: %d", version)
    center_print_(v, 79)
    border_print_()

end

function border_print_()
    printf(
        "===================================================================" *
        "=============\n",
    )
end

# Prints Section titles in center of 80 char terminal
function center_print_(s::String, width::Int32)

    length::Int32 = length(s)
    for i = 0:(width-length)/2
        print(" ")
    end
    println(s)

end



function read_CLI(args::String[])::Inputs

    input::Inputs

    ## defaults to the history based simulation method
    input.simulation_method = HISTORY_BASED

    ## defaults to max threads on the system	
    input.nthreads = Threads.nthreads()

    ## defaults to 355 (corresponding to H-M Large benchmark)
    input.n_isotopes = 355

    ## defaults to 11303 (corresponding to H-M Large benchmark)
    input.n_gridpoints = 11303

    ## defaults to 500,000
    input.particles = 500000

    ## defaults to 34
    input.lookups = 34

    ## default to unionized grid
    input.grid_type = UNIONIZED

    ## default to unionized grid
    input.hash_bins = 10000

    ## default to no binary read/write
    input.binary_mode = NONE

    ## defaults to baseline kernel
    input.kernel_id = 0

    ## defaults to H-M Large benchmark
    input.HM = "large"

    ## Check if user sets these
    user_g = 0
    default_lookups = 1
    default_particles = 1

    parse_settings = ArgParseSettings("XSBench.jl argument settings.")

    @add_arg_table! parse_settings begin
        "-g"
        help = "n_gridpoints"
        arg_type = Int64
        default = 11303
        "-m"
        help = "Simulation Method"
        arg_type = String

        "-l"
        help = "lookups"
        "-h"
        help = "hash bins"
        "-p"
        help = "particles"
        "-s"
        help = "HM"
        "-G"
        help = "grid type"
        "-b"
        help = "binary mode"
        "-k"
        help = "kernel optimization selection"
    end

    for (key, val) in parsed_args
        println("  $key  =>  $(repr(val))")
    end

end
