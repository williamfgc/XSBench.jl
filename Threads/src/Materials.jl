


function LCG_random_double(seed::UInt64)::Tuple{UInt64,Float64}

    m::UInt64 = 9_223_372_036_854_775_808 # 2^63
    a::UInt64 = 2_806_196_910_506_780_709
    c::UInt64 = 1
    new_seed::UInt64 = (a * seed + c) % m
    new_seed_d::Float64 = Float64(new_seed) / Float64(m)
    return new_seed, new_seed_d
end

@doc """
num_nucs represents the number of nuclides that each material contains
"""
function load_num_nucs(n_isotopes::Int64)::Array{Int32,1}

    num_nucs = Array{Int32,1}(undef, 12)
    # Material 1 is a special case (fuel). The H-M small reactor uses
    # HM small is 34, H-M large is 321 nuclides
    n_isotopes == 68 ? num_nucs[1] = 34 : num_nucs[1] = 321

    num_nucs[2:12] = [5, 4, 4, 27, 21, 21, 21, 21, 21, 9, 9]
    return num_nucs
end


@doc """
Assigns an array of nuclide ID's to each material
return a tuple
"""
function load_mats(
    num_nucs::Array{Int32,1},
    n_isotopes::Int64,
)::Tuple{Int32,Array{Int32,2}}

    max_num_nucs = findmax(num_nucs)[1]
    mats = Array{Int32,2}(undef, max_num_nucs, 12)

    # Small H-M has 34 fuel nuclides
    #! format: off
    mats[1:34,1] = Int32[ 58, 59, 60, 61, 40, 42, 43, 44, 45, 46,  
                           1,  2,  3,  7,  8,  9, 10, 29, 57, 47, 48,  
                           0, 62, 15, 33, 34, 52, 53, 54, 55, 56, 18, 23, 41 ]

    ## Large H-M has 300 fuel nuclides
    if n_isotopes != 68
        for i = 35:321
            mats[i, 1] = 68 + i
        end
    end

    # # These are the non-fuel materials	
    mats[1:5, 2] = Int32[63, 64, 65, 66, 67] # cladding
    mats[1:4, 3] = Int32[24, 41,  4, 5] # cold borated water
    mats[1:4, 4] = Int32[24, 41,  4, 5] # hot borated water

    mats[1:27, 5] = Int32[19, 20, 21, 22, 35, 36, 37, 38, 39, 25, 27, 28, 29,
                          30, 31, 32, 26, 49, 50, 51, 11, 12, 13, 14, 6, 16, 17 ] # RPV

    mats[1:21, 6] = Int32[24, 41, 4, 5, 19, 20, 21, 22, 35, 36, 37, 38, 39, 25, 49, 50, 51, 
                          11, 12, 13, 14] # lower radial reflector

    mats[1:21, 7] = Int32[ 24, 41, 4, 5, 19, 20, 21, 22, 35, 36, 37, 38, 39, 25, 49, 50, 51, 
                           11, 12, 13, 14] # top reflector / plate

    mats[1:21, 8] = Int32[ 24, 41, 4, 5, 19, 20, 21, 22, 35, 36, 37, 38, 39, 25, 49, 50, 51, 
                           11, 12, 13, 14 ] # bottom plate
    
    mats[1:21, 9] = Int32[ 24, 41, 4, 5, 19, 20, 21, 22, 35, 36, 37, 38, 39, 25, 49, 50, 51, 
                           11, 12, 13, 14 ] # bottom nozzle

    mats[1:21, 9] = Int32[ 24, 41, 4, 5, 19, 20, 21, 22, 35, 36, 37, 38, 39, 25, 49, 50, 51, 
                           11, 12, 13, 14 ] # top nozzle
    
    mats[1:9, 11] = Int32[24, 41, 4, 5, 63, 64, 65, 66, 67] # top of FA's

    mats[1:9, 12] = Int32[24, 41, 4, 5, 63, 64, 65, 66, 67] # bottom FA's
    
    #! format: on

    return max_num_nucs, mats
end


function load_concs(
    num_nucs::Array{Int32,1},
    max_num_nucs::Int32,
)::Array{Float64,2}

    seed::UInt64 = 1070 * 1070
    concs = Array{Float64,2}(undef, max_num_nucs, 12)

    for i = 1:12
        for j = 1:num_nucs[i]
            seed, concs[j, i] = LCG_random_double(seed)
        end
    end

    return concs
end
