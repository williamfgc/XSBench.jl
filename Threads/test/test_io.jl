
using Test
import XSBenchThreads

@testset "io" begin
    args::Array{String,1} = ["-g", "32000", "-m", "this_method"]
    inputs = XSBenchThreads.read_CLI(args)
    println(inputs)
    @test inputs.n_gridpoints == 32_000
end
