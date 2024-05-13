using FFTW
using Plots
using JLD2
using StatsBase
using FiniteDiff

#READ: Loading in data using the JLD2 file type

# --Load in data
    file_data = load("../Pluto Notebooks/Raw Data/Sim 2/Correlation_Results_Sim_2.jld2");
    SNRs = file_data["W_SNR"];
    detection::Vector{Float64} = file_data["W_results"];
    
    file_data = load("../Pluto Notebooks/Raw Data/Sim 2/poly100_KCC_Results_Sim_2.jld2");
    SNRs_2 = file_data["W_SNR"];
    detection_2::Vector{Float64} = file_data["W_results"];

# --Plotting Basic Data
    scatter(SNRs, detection, 
            label = "Cross-Correlation Simulation Results",
            legendfont = "Computer Modern",
            guidefont = ("Computer Modern"),
            xlabel = "SNR (dB)",
            ylabel = "Detection Probability",
            tickfont = "Computer Modern",
            title = "SNR Curves and Connection to the Weibull Distribution",
            titlefont = (12, "Computer Modern"),
            xlims = (-55,1),
            dpi = 500,
            legend = :bottomright)
    
###################################################################################################
#                                       Fitting                                                   #
###################################################################################################

# --Fitting a Weibull CDF to curve
    x = 1:0.01:130;
    λ = 6.5;
    weibull = 1 .- exp.(-((x .+ 10)./73) .^ λ);
    xaxis = LinRange(-55, 0, length(x));

    plot!(xaxis, weibull, 
          label = "Weibull Distribution Function (λ = 6.5)",
          linewidth = 2);
   
# --Finding the derivative of the weibull distribution
    first_derivative = 1 .* (((x .+ 10)./73).^ (λ - 1)) .* exp.(-((x .+ 10)./73) .^ λ);
    plot!(xaxis, first_derivative ./ maximum(first_derivative), 
          label = "Weibull Probability Density",
          linewidth = 2)
    
    savefig("Derivative of Correlation curve.pdf")   

###################################################################################################
#                                       Curve Fitting 2                                           #
###################################################################################################

# --Scatter plot 2
    scatter(SNRs_2, detection_2,
            label = "Polynomial Kernel Simulation Results",
            legendfont = "Computer Modern",
            guidefont = ("Computer Modern"),
            xlabel = "SNR (dB)",
            ylabel = "Detection Probability",
            tickfont = "Computer Modern",
            title = "SNR Curves and Connection to the Weibull Distribution",
            titlefont = (12, "Computer Modern"),
            xlims = (-55,1),
            dpi = 500,
            legend = :bottomright)

# --Fitting a Weibull CDF to curve
    x = 1:0.01:130;
    λ = 2.05;
    weibull = 1 .- exp.(-((x .+ 10)./65) .^ λ);
    xaxis = LinRange(-55, 0, length(x));

    plot!(xaxis, weibull, 
          label = "Weibull Distribution Function (λ = 2.05)",
          linewidth = 2);
   
# --Finding the derivative of the weibull distribution
    first_derivative = 1 .* (((x .+ 10)./70).^ (λ - 1)) .* exp.(-((x .+ 10)./73) .^ λ);
    # plot!(xaxis, first_derivative ./ maximum(first_derivative), 
    #       label = "Weibull Probability Density",
    #       linewidth = 2)
    #  
    savefig("Large Degree Polynomial Curve.pdf")
