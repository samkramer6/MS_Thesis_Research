#=  time_domain_finder()
    This function is a helper function for the find chirps algorithm that is used to analyze the
    bat data to find the chirps that have been detected by the microphones. This uses the time 
    domain signal that has been collected by the array. This compares the CFFM chirp from actual
    data to the filtered dataset. 

    Sam Kramer
    September 1st, 2023
=#

# --Include statements


# --Using Statements
using StatsBase

# --Function Definition
function time_domain_finder(filtered_data,fs,FM_chirp,CFFM_chirp,weight)

    # --Cross correlate data sets
        FM_corr = crosscor(filtered_data, FM_chirp);
        CFFM_corr = crosscor(filtered_data, CFFM_corr);

    # --Reformat data to find just the single sided cross correlation


    # --Develop peak threshold criteria


    # --Find peaks of both correlation sets {Calls five_peak_finder}


    # --cpmpare the peaks of both {Calls compare_function()}


end