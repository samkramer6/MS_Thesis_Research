#=  kxcorr.jl

=#

# --Using statements
    using CUDA
    using CUDA.CUFFT

# --Function Definition
    function kxcorr(data, sample)

        # --Parameters for calculations
            sigma = 0.3;
            lambda = 0.0015;

        # --Convert data to CuArray types in freq domain
            f_data = fft(CuArray(data));
            f_sample = fft(CuArray(sample));

        # --Call on train function
            f_correlator = train(sample, lambda, sigma);

        # --Kernel of data (calls kernel_gauss)
            f_kernel = kernel_gauss(f_data, f_sample, sigma);
            output = Array(ifft(f_correlator.*f_kernel));
            output = abs.(output);
            response = max(output);

        return response, output
    end


