import ArgParse

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



function read_CLI(args::Array{String,1})::Inputs

    ## Check if user sets these
    user_g = 0
    default_lookups = 1
    default_particles = 1

    parse_settings = ArgParse.ArgParseSettings("XSBench.jl argument settings.")

    ArgParse.@add_arg_table! parse_settings begin
        "-g"
        help = "Number of Grid Points"
        arg_type = Int64
        default = Int64(11303)
        "-m"
        help = "Simulation Method"
        arg_type = String
        default = "history"
        "-l"
        help = "Lookups"
        arg_type = Int32
        default = Int32(34)
        # using upper case H since h is reserved when add_help is true 
        # https://argparsejl.readthedocs.io/en/latest/argparse.html#general-settings 
        "-H"
        help = "Hash Bins"
        arg_type = Int32
        default = Int32(10000)
        "-p"
        help = "Particles"
        arg_type = Int32
        default = Int32(500000)
        "-s"
        help = "HM"
        arg_type = String
        default = "large"
        "-G"
        help = "Grid Type"
        arg_type = String
        default = "unionized"
        "-b"
        help = "Binary Mode"
        arg_type = String
        default = "none"
        "-k"
        help = "Kernel Optimization Selection"
        arg_type = Int32
        default = Int32(0)
    end

    parsed_args = ArgParse.parse_args(args, parse_settings)

    # println("Parse settings ", parsed_args)

    # println("Print map:")
    inputs = Inputs()

    for (key, value) in parsed_args
        #println(key, " => ", value)

        if key == "g"
            inputs.n_gridpoints = value

        elseif key == "m"

        elseif key == "l"

        elseif key == "H"

        elseif key == "p"

        elseif key == "s"

        elseif key == "G"

        elseif key == "b"

        elseif key == "k"

        end

    end

    return inputs

end
