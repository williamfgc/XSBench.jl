module XSBenchThreads

# struct
export Inputs, SimulationData
# functions
export read_CLI, grid_init_do_not_profile

mutable struct Inputs
    nthreads::Int32
    n_isotopes::Int64
    n_gridpoints::Int64
    lookups::Int32
    HM::String
    grid_type::String
    hash_bins::Int32
    particles::Int32
    simulation_method::String
    binary_mode::String
    kernel_id::Int32

    Inputs() = new(
        Threads.nthreads(),
        Int64(355),
        Int64(11303),
        Int32(34),
        "large",
        "unionized",
        Int32(10_000),
        Int32(500_000),
        "history_based",
        "none",
        Int32(0),
    )
end

mutable struct NuclideGridPoint
    energy::Float64
    total_xs::Float64
    elastic_xs::Float64
    absorption_xs::Float64
    fission_xs::Float64
    nu_fission_xs::Float64

    NuclideGridPoint() = new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
end


mutable struct SimulationData
    num_nucs::Array{Int32,1}
    length_nuclide_grid::Int32
    nuclide_grid::Array{NuclideGridPoint,1}

    SimulationData() = new(Array{Int32,1}[], Int32(0), Array{NuclideGridPoint,1}[])
end


include("io.jl")
include("GridInit.jl")


end
