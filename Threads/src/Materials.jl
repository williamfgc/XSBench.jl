

@doc """
num_nucs represents the number of nuclides that each material contains
"""
function load_num_nucs(n_isotopes::Int64)::Array{Int32,1}

    num_nucs = Array{Int32,1}(undef, 12)
    # Material 0 is a special case (fuel). The H-M small reactor uses
    # 34 nuclides, while H-M larges uses 300.

    # HM small is 34, H-M large is 321 nuclides
    if n_isotopes == 68
        num_nucs[0] = 34
    else
        num_nucs[0] = 321
    end

    num_nucs[1] = 5
    num_nucs[2] = 4
    num_nucs[3] = 4
    num_nucs[4] = 27
    num_nucs[5] = 21
    num_nucs[6] = 21
    num_nucs[7] = 21
    num_nucs[8] = 21
    num_nucs[9] = 21
    num_nucs[10] = 9
    num_nucs[11] = 9

    return num_nucs

end


@doc """
Assigns an array of nuclide ID's to each material
return a tuple
"""
function load_mats(num_nucs::Array{Int32,1}, n_isotopes::Int64)::Tuple{Int32,Array{Int32,2}}

    max_num_nucs = findmax(num_nucs)[1]
    mats = Array{Int32,2}(undef, max_num_nucs, 12)

    # Small H-M has 34 fuel nuclides
    mats[:, 1] = [
        58 59 60 61 40 42 43 44 45 46 1 2 3 7
        8 9 10 29 57 47 48 0 62 15 33 34 52 53
        54 55 56 18 23 41
    ]
    ## Large H-M has 300 fuel nuclides
    if n_isotopes != 68
        for i = 35:321
            mats[i, 1] = 68 + i
        end
    end

    # These are the non-fuel materials	
    mats[:, 2] = [63 64 65 66 67] # cladding

    mats[:, 3] = [24 41 4 5] # cold borated water

    mats[:, 4] = [24 41 4 5] # hot borated water

    mats[:, 5] = [
        19 20 21 22 35 36 37 38 39 25 27 28 29
        30 31 32 26 49 50 51 11 12 13 14 6 16
        17
    ] # RPV

    mats[:, 6] = [
        24 41 4 5 19 20 21 22 35 36 37 38 39 25
        49 50 51 11 12 13 14
    ] # lower radial reflector

    mats[:, 7] = [
        24 41 4 5 19 20 21 22 35 36 37 38 39 25
        49 50 51 11 12 13 14
    ] # top reflector / plate

    mats[:, 8] = [
        24 41 4 5 19 20 21 22 35 36 37 38 39 25
        49 50 51 11 12 13 14
    ] # bottom plate

    mats[:, 9] = [
        24 41 4 5 19 20 21 22 35 36 37 38 39 25
        49 50 51 11 12 13 14
    ] # bottom nozzle

    mats[:, 10] = [
        24 41 4 5 19 20 21 22 35 36 37 38 39 25
        49 50 51 11 12 13 14
    ] # top nozzle

    mats[:, 11] = [24 41 4 5 63 64 65 66 67] # top of FA's

    mats[:, 12] = [24 41 4 5 63 64 65 66 67] # bottom FA's

    return max_num_nucs, mats
end
