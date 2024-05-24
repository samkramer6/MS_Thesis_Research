#=  window_functions.jl 
    
    This is the code for the generation of the window functions and their DFTs. For a given window
    function there will be a specific DFT output.

=# 

using Plots
    gr()
using FFTW
using Distributions
using LaTeXStrings

###################################################################################################
#                                             Windows                                             #
###################################################################################################

# --Triangluar Window
    K = 128;
    k = LinRange(-K/2, K/2, K);
    w_triangle = 1.0 .- abs.(k) ./ (length(k) ./ 2); 

    plot(k, w_triangle, 
         show = true,
         xlabel = " ",
         ylabel = " ",
         tickfont = "Computer Modern",
         color = :black,
         linewidth = 1.5,
         line = :stem,
         label = false,
         )
    savefig("Triangle_window.pdf")

# --Cos^2 Hann window
    α = 2; 
    w_Hann = cos.(π .* k ./ K) .^ α;

    plot(k, w_Hann,
         show = true,
         xlabel = " ",
         ylabel = " ",
         tickfont = "Computer Modern",
         color = :black,
         linewidth = 1.5,
         line = :stem,
         label = false,
         )
    savefig("Hann_window.pdf") 

###################################################################################################
#                                               DFT of Windows                                    #
###################################################################################################

# --DFT Triangle window
    K = 256;
    k = LinRange(-K/2, K/2, K);
    w_triangle = 1.0 .- abs.(k) ./ (length(k) ./ 2); 

    f_w_triangle = fftshift(abs.(fft(w_triangle)));
    f_w_triangle_dB = 20 .* log10.(f_w_triangle ./ maximum(f_w_triangle)); 
    freq = (1 ./ K) .* (-K/2:K/2 - 1) .* (2 * π); 
    plot(freq, f_w_triangle_dB,
         label = false,
         xlabel = " ",
         ylabel = " ",
         tickfont = "Computer Modern",
         color = :black,
         linewidth = 1.5,
         ylim = (-100, 0),
         xlim = (-π, π),
         xtick = ([-π, -π/2, 0, π/2, π],[L"-π"," ", "0", " ", L"π"]),
         )
    savefig("DFT_triangle_window.pdf")

# --DFT Hann Function
    K = 256;
    k = LinRange(-K/2, K/2, K);
    w_Hann = 0.5 .+ 0.5 .* cos.(2 .* k .* π ./ K); 

    f_w_Hann = fftshift(abs.(fft(w_Hann)));
    f_w_Hann_dB = 20 .* log10.(f_w_Hann ./ maximum(f_w_Hann)); 
    freq = (1 ./ K) .* (-K/2:K/2 - 1) .* (2 * π); 
    plot(freq, f_w_Hann_dB,
         label = false,
         xlabel = " ",
         ylabel = " ",
         tickfont = "Computer Modern",
         color = :black,
         linewidth = 1.5,
         ylim = (-100, 0),
         xlim = (-π, π),
         xtick = ([-π, -π/2, 0, π/2, π],[L"-π"," ", "0", " ", L"π"]),
         )
    savefig("DFT_Hann_window.pdf")


