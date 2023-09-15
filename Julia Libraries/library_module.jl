#=  library_module.jl
    This is the module that is defined for the find chirps algorithm

=#

module library

    # --Include Function Definition Files
        include("load_data.jl")     # load_data() function include statement
        include("spectrogram_function.jl")
        include("five_peak_finder.jl")
        include("create_chirp.jl")
        include("filter_data.jl")
        include("compare_function.jl")


    # --Export List
        export load_data
        export spectrogram_function
        export five_peak_finder
        export create_chirp
        export filter_data
        export compare_function

end
