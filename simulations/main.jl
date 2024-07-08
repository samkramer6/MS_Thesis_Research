# This is the main document for the simulation

include("helper_functions.jl")

using BenchmarkTools

####################################################################################

function main()

    # --Parameters
    α = range(1.0,10.0);
    β = range(1.0, 10.0, length(α));
    num_sims = 100;
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
            
            detection_output::Detection = roll_dice(data, α[i], β[i]);
            
            SNR_result[j] = detection_output.SNR;
            detection_result[j] = detection_output.detection[1]; 

        end 
        
        SNRs[i] = mean(SNR_result);
        Probabilities[i] = mean(detection_result);         
     
    end

    

end

@btime main()
