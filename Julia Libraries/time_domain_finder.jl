#=  time_domain_finder()
    This function is a helper function for the find chirps algorithm that is used to analyze the
    bat data to find the chirps that have been detected by the microphones. This uses the time 
    domain signal that has been collected by the array. This compares the CFFM chirp from actual
    data to the filtered dataset. 

    Sam Kramer
    September 1st, 2023
=#

# --Using Statements
using StatsBase

# --Function Definition
function time_domain_finder(filtered_data, fs, FM_chirp, CFFM_chirp, weight)

# --Cross correlate data sets
    lags = 0:length(filtered_data) - 1;
    FM_corr = crosscor(filtered_data, FM_chirp, lags, demean = true);
    FM_corr = vec(FM_corr);
    CFFM_corr = crosscor(filtered_data, CFFM_chirp, lags, demean = true);
    CFFM_corr = vec(CFFM_corr);

# --Develop peak threshold criteria
    CF_corr = abs.(CFFM_corr);
    FM_corr = abs.(FM_corr);
    A = findmax(CFFM_corr);
    B = findmax(FM_corr);
    CFFM_peak_threshold = A[1] .- 2*mean(CFFM_corr);
    FM_peak_threshold = B[1] .- weight*mean(FM_corr);

# --Find peaks of both correlation sets {Calls five_peak_finder}
    CF_ind = five_peak_finder(CF_corr, CFFM_peak_threshold);
    FM_ind = five_peak_finder(FM_corr, FM_peak_threshold);

# --cpmpare the peaks of both {Calls compare_function()}
    indeces = CF_ind./fs;
    time_indeces = compare_function(indeces, 0.001);   # Returns type Vec{Float64}

    return time_indeces::Vector{Float64}
end