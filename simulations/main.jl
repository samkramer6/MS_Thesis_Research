# This is the main document for the simulation

include("helper_functions.jl")

using BenchmarkTools
using Plots
    gr()
using Timers
using PlotThemes

####################################################################################

function main(algorithm::String, noise::String)

    # --Parameters
    Timers.tic()
    α = range(2.0, 151.0);
    num_points = length(α); 
    β = range(7.5, 0.1 , num_points);
    num_sims = 2000;
    SNRs::Vector{Float64} = vec(zeros(Bool, 1, length(α)));
    Probabilities::Vector{Float64} = vec(zeros(Float64, 1, length(α)));

    # --Populate Signal
    data = Data((), (), (), (), (), 1024, ());
    populate_signal!(data);

    # --Outer for loop (SNR loop)
    for i in collect(range(1, length(α)))
        
        detection_result::BitVector = BitVector(undef, num_sims);  
        SNR_result::Vector{Float64} = vec(zeros(Float64, 1, num_sims));

        for j in collect(range(1, num_sims)) 
            
            detection_output::Detection = roll_dice(data, α[i], β[i], algorithm, noise);
            
            @inbounds SNR_result[j] = detection_output.SNR;
            @inbounds detection_result[j] = detection_output.detection[1]; 

        end 
        
        @inbounds SNRs[i] = mean(SNR_result);
        @inbounds Probabilities[i] = mean(detection_result);         
     
    end

    # --Plot
    plot!(SNRs, Probabilities,
         xlims = (-50, 5), 
         ylims = (0, 1.05),
         label = "Detection Probability Distribution",
         guidefont = "Computer Modern",
         xlabel = "SNR (dB)",
         # ylabel = "Detection Probability",
         tickfont = "Computer Modern",
         linewidth = 1.5,
         legendfont = "Computer Modern",
         theme = :bright,
    )

    # --Out Statement
    num_total_sims = num_points * num_sims;
    println("====== SIM DONE ======")
    println("Algorithm Used: $algorithm") 
    println("Noise Type Used = $noise") 
    println("sims per point = $num_sims")
    println("Total Sims = $num_total_sims \n")
    Timers.toc()

end

###################################################################################################

plot()
main("Cross-Correlation", "White")
main("Matched Filter", "White")
main("Cross-Correlation", "Red")
main("Matched Filter", "Red")
savefig("Detection_Output.png")

