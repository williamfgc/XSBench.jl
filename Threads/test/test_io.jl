


function test_args_parsing()::Bool
    args::Array{String,1} = ["-g", "32000", "-m", "this_method"]
    XSBenchThreads.read_CLI(args)

    return true
end


@test test_args_parsing() == true
