# --Using Statements
    using CUDA
    using CUDA.CUFFT
    using StatsBase
    

# --Gaussian CUDA Kernel function
function gauss_kernel_CUDA(xf::CuArray, yf::CuArray, sigma)

	# --Setup parameters
		N = length(xf)

	# --Perform Auto and Cross correlations
		xx = abs.(xf' * xf ./ N);
		yy = abs.(yf' * yf ./ N);
		xy = CUFFT.ifft(xf .* conj.(yf));

	# --Compute Kernel Transformation
		kf = exp.(-1 ./ sigma^2 .* (xx + yy .- 2 .* xy) ./ N)
		output = abs.(kf);

	return output::CuArray{Float64}
end