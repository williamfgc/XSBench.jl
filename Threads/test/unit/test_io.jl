
using Test
import XSBenchThreads
import ArgParse

@testset "inputs" begin
    args::Array{String,1} = ["-g", "32000", "-m", "event"]
    inputs = XSBenchThreads.read_CLI(args)
    @test inputs.n_gridpoints == 32_000
end

@testset "inputs_exception" begin
    args::Array{String,1} = ["-g", "0", "-m", "this_method"]
    @test_throws ArgParse.ArgParseError("out of range input for -g: 0") XSBenchThreads.read_CLI(
        args,
    )
end
