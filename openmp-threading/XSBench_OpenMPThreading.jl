
import MPI
import ArgParse
import Threads
import XSBenchOpenMPThreading

module XSBenchOpenMPThreading

# struct
export Inputs
# functions
export read_CLI

HISTORY_BASED::Int32 = 1

include("io.jl")

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


end
