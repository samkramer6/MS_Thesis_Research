#=  

=#


# --Using Statements


# --Function Definition
    function train(f_sample, lambda, sigma)

        # --Define Struct
            struct correlator
                sigma::Float64;
                f_correlator::CuArray{Float64};
                f_sample::CuArray{Float64};
            end
        
        # --Parameters
            target_fft = ones(length(sample),1);
            correlator.f_sample = f_sample;
            correlator.sigma = sigma;

        # --Call kernel and calculator kernel function
            kernel = kernel_gauss(f_sample, f_sample, sigma);
            correlator.f_correlator = target_fft./(kernel .+ lambda);

    end