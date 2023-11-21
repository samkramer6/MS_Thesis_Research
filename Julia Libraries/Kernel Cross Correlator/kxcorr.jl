#=  kxcorr.jl

=#

# --Using statements
    using DSP
    using StatsBase
    using AbstractFFTs
    

# --Function Definition
function kxcorr(data::Vector, sample)

	# --Test for correct type of vector
		if ndims(data) != 1
			data_vec = vec(data);
		end

	# --Zero Pad data to make the same length
		if length(sample) < length(data)
			diff = length(data) - length(sample);
			pad = zeros(diff);
			ref_sig = [sample; pad];
		end

	# --parameters
		lambda = 0.001;
		sigma = 0.2;

	# --Setup
			data_fft = fft(data);
			ref_sig_fft = fft(ref_sig);

	# --Train
		h_hat = train(data, ref_sig, ref_sig_fft, lambda, sigma);
	
	# --Compute output
		kernel_fft = fft(gauss_kernel(data_fft, ref_sig_fft, sigma));
		output = abs.(ifft(h_hat .* kernel_fft));
		corr_output = output .- mean(output);

	return corr_output
end