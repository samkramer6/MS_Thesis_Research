using Plots
    gr()
using Distributions
using FFTW 

# --Develop Signal
    T = 1;
    fs = 1024;
    time = collect(0:1/fs:T - (1/fs));
    window = sin.(π .* time) .^ 2;  # Hann Window function
    f = 2 .* 10 .* π;

    signal = 1 .* window .* sin.(f .* time);
    signal_long = append!(vec(zeros(Float64, 1, length(time))), signal, vec(zeros(Float64, 1, length(time))));

    noise = vec(rand(Normal(0, 0.4), 1, length(signal_long)));    
    noisy_signal = noise .+ signal_long;

# --Plotting out the data
    time_long = collect(0:1/fs:(3*T - (1/fs)));
    p1 = plot(time, signal,
              xlabel = "Time (s)",
              ylabel = "Signal Amplitude",
              title = "Reference Wavelet",
              label = false,
              guidefont = "Computer Modern",
              tickfont = "Computer Modern",
              titlefont = "Computer Modern",
              ); 
    p2 = plot(time_long, noisy_signal,
              xlabel = "Time (s)",
              ylabel = "Signal Amplitude",
              title = "Noisy Data Set",
              label = false,
              guidefont = "Computer Modern",
              tickfont = "Computer Modern",
              titlefont = "Computer Modern",
              ); 
    
    plot(p1, p2, 
         layout = [1, 1]
         )
    savefig("original_datasets.pdf")
    
    histogram(noise, 
              nbins = 40,
              label = false,
              xlabel = "Noise Amplitude",
              ylabel = "Occurance",
              title = "Histogram of Noise",
              guidefont = "Computer Modern",
              tickfont = "Computer Modern",
              titlefont = "Computer Modern",
              ); 
    savefig("noise_histogram.pdf")
    
###################################################################################################
#                                           Transformation                                        #
###################################################################################################

# --Transforming data and references 
    n = 15; 
    k_data = (noisy_signal .+ 0.5) .^ n; 

# --Making a reference signal
    reference = vcat(signal_long[1024:end], signal_long[1:1023]);
    k_reference = (reference .+ 0.5) .^ n;
    
# --Plotting out the transformed data 
    # p3 = plot(time_long, k_reference./maximum(k_reference),
    #           xlabel = "Time (s)",
    #           ylabel = "Transformed Amplitude",
    #           title = "Transformed Reference",
    #           guidefont = (8,"Computer Modern"),
    #           tickfont = "Computer Modern",
    #           titlefont = "Computer Modern",
    #           label = false,
    #           ); 
    plot(time_long, k_data./maximum(k_data),
              xlabel = "Time (s)",
              ylabel = "ϕ(x)",
              title = "Transformed Data Set",
              guidefont = (8,"Computer Modern"),
              tickfont = "Computer Modern",
              titlefont = "Computer Modern",
              label = false,
              );     
    savefig("transformed_data.pdf") 

# --Taking Correlation between the two data sets
    fk_data = fft(k_data);
    fk_reference = fft(k_reference);
    correlation = abs.(ifft(fk_data .* conj(fk_reference)));
    
    plot(correlation./maximum(correlation),
         xlabel = "Lags (τ)",
         ylabel = "Correlation Amplitude",
         title = "Kernel Cross-Correlation Output",
         label = false,
         guidefont = (8,"Computer Modern"), 
         tickfont = "Computer Modern", 
         titlefont = "Computer Modern",
         ); 
    savefig("correlation_output.pdf") 

