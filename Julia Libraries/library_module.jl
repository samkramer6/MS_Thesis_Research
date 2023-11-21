module library

    # --Include Function Definition Files
        include("load_data.jl")     # load_data() function include statement
        include("spectrogram_function.jl")
        include("five_peak_finder.jl")
        include("create_chirp.jl")
        include("filter_data.jl")
        include("compare_function.jl")
        include("time_domain_finder.jl")

    # --Kernel Cross Correlator Functions
        include("Kernel Cross Correlator//kernel_gauss_CUDA.jl")
        include("Kernel Cross Correlator//kernel_gauss.jl")
        include("Kernel Cross Correlator//kxcorr_CUDA.jl")
        include("Kernel Cross Correlator//kxcorr.jl")
        include("Kernel Cross Correlator//train_CUDA.jl")
        include("Kernel Cross Correlator//train.jl")


    # --Export List
        export load_data
        export spectrogram_function
        export five_peak_finder
        export create_chirp
        export filter_data
        export compare_function
        export time_domain_finder

        export gauss_kernel_CUDA
        export gauss_kernel
        export kxcorr
        export kxcorr_CUDA
        export train
        export train_CUDA

end
