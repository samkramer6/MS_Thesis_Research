# --Using Definitions
    using CUDA
    using CUDA.CUFFT
    using DSP
    using StatsBase

# --Function definition
function kxcorr_CUDA(data::Vector, sample::Vector)

	# --Test for correct type of vector
		if ndims(data) != 1
			data_vec = vec(data);
		end

	# --Zero Pad data to make the same length
		if length(sample) < length(data)
			diff = length(data) - length(sample);
			pad = zeros(diff);
			ref_sig = [sample; pad];
		else
			ref_sig = sample;
		end

	# --Convert to CUDA type
		data_CUDA = CuArray(data);
		ref_sig_CUDA = CuArray(ref_sig);

	# --parameters
		lambda = 0.001;
		sigma = 0.2;

	# --Setup
		data_fft = CUFFT.fft(data_CUDA);
		ref_sig_fft = CUFFT.fft(ref_sig_CUDA);

	# --Train
		h_hat = train_CUDA(data_CUDA, ref_sig_CUDA, ref_sig_fft, lambda, sigma);
	
	# --Compute output
		kernel_fft = CUFFT.fft(gauss_kernel_CUDA(data_fft, ref_sig_fft, sigma));
		output = abs.(CUFFT.ifft(h_hat .* kernel_fft));
		corr_output_CUDA = output .- mean(output);

	# --Convert to regular types
		corr_output = Array(corr_output_CUDA);

	return corr_output::Vector{Float64}
end