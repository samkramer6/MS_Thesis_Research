using Plots
    gr()
using Distributions

# --Making original signal
    T = 1; 
    fs = 10000;
    time = collect(0:1/fs:T);
    window = sin.(π .* time).^2;  # Hann Window function
    f = 10 .* 2 .* pi;

    signal = window .* sin.(f .* time);
    signal = append!(vec(zeros(Float64, 1, length(time))), signal, vec(zeros(Float64, 1, length(time))));
    
    noise = vec(rand(Normal(0, 0.26), 1, length(signal)));    
    noisy_signal = noise .+ signal;

    plot(noisy_signal, show = false)
    savefig("figure_test.png")

    histogram(noisy_signal, show = false, bins = 35)
    savefig("Histogram_figure.png")

# --Function Defintions
    function kernel(x, n)

        kx = (x .+ 0.5) .^ n;

        return kx
    end

# --Kernel Transformations of the data
    k_signal = kernel(noisy_signal, 100); 
    
    plot(k_signal, show = false)
    savefig("Kernel_transform.png")

