
using Test
import XSBenchThreads
import ArgParse

include("../../src/Main.jl")

@testset "test_main" begin
    @test main(["-g", "10", "-m", "event"]) == 0
end
