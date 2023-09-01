#=  library_module.jl
    This is the module that is defined for the find chirps algorithm

=#

module library

    # --Include Function Definition Files
        include("load_data.jl")     # load_data() function include statement
        include("spectrogram_function.jl")

    # --Export List
        export load_data
        export spectrogram_function

end
