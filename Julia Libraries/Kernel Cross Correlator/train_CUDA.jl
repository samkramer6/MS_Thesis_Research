# --Using Statements
    using CUDA
    using CUDA.CUFFT
    using StatsBase

# --Train function in CUDA
function train_CUDA(data::CuArray, sample::CuArray, sample_fft, lambda, sigma)
	
	# --Calculating Correlator
		kernel = gauss_kernel_CUDA(sample_fft, sample_fft, sigma);
		kernel = kernel .- mean(kernel);
		k_z = fft(kernel);

	# --Define training objective

		# --Triangular wave trainer
			x = collect(0:length(sample)/2);
			b = [x; reverse(x)];
			c = b[1:length(data)];
			g_hat = 1/maximum(c) .* c;
			g_hat_CUDA = CuArray(g_hat)
			g_hat_1f = abs.(CUFFT.fft(g_hat_CUDA)); 		# Will be a vector type

		# --Correlation Trainer
			g_hat_2 = xcorr(data, sample) ./ length(data); 		# requires DSP
			g_hat_3 = g_hat_2[length(sample) : end];
			g_hat_2f = abs.(CUFFT.fft(g_hat_3));
			target = g_hat_1f .* g_hat_2f;

	# --Define h_hat for our system (used h_hat = g_hat ./ k(ref_sig));
		h_hat = target ./ (k_z .+ lambda);

	return h_hat::CuArray
end