using Plots
    gr()
using Distributions
using FFTW

# NOTE: Functions must be defined before method call

# --Function Defintions
    function kernel(x, n)

        kx = (x .+ 1) .^ n;

        return kx
    end

    function SNR(noise, signal)
        
        noise_power = sum(noise .^ 2) / length(noise);
        signal_power = sum(signal .^ 2) / length(signal);

        SNR = 10 .* log10(signal_power / noise_power);

        return SNR::Float64
    end

    function numerical_diff(SNR, data)

        data = data .- mean(data); 
        f_data = fft(data);

        T = SNR[end] - SNR[1];
        n = length(data);
        frequencies = abs.((2 .* π /T) .* collect(1:n));
        omega = fftshift(frequencies);      #NOTE: Shifts the frequencies for our freq vector 
        
        diff = 1im .* frequencies .* f_data;
        diff = real.(ifft(diff));

        return diff::Vector{Float64}
    end


# --Making original signal
    T = 1; 
    fs = 10000;
    time = collect(0:1/fs:T);
    window = sin.(π .* time).^2;  # Hann Window function
    f = 10 * 2 * π;

    signal = window .* sin.(f .* time);
    signal_long = append!(vec(zeros(Float64, 1, length(time))), signal, vec(zeros(Float64, 1, length(time))));
    
    noise = vec(rand(Normal(0, 0.4), 1, length(signal_long)));    
    noisy_signal = noise .+ signal_long;

    plot(noisy_signal, time, label = "Signal")
    savefig("figure_test.png")

    histogram(noisy_signal, show = false, bins = 35)
    savefig("Histogram_figure.png")

# --Kernel Transformations of the data
    k_signal = kernel(noisy_signal, 50); 
    
    plot(k_signal, show = false)
    savefig("Kernel_transform.png")

# --Finding SNR
    snr = SNR(noise, signal);
    @show snr  

# --PSD of Noise
    psd_noise = abs.(fft(noise) .* conj(fft(noise)));
    psd_noise = 20 .* log10.(psd_noise);
    frequencies = (1/T) .* (1:length(psd_noise)); 
    
    plot(frequencies, psd_noise, xaxis = :log) 
    savefig("PSD_noise.png")
