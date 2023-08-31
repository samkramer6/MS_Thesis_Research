#=  library_module.jl
    This is the module that is defined for the find chirps algorithm

=#

module library

    # --Function Definitions
        include("load_data.jl")     # load_data() function include statement

    # --Export List
        export load_data

end
