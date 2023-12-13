function time_indeces = time_domain_finder(filtered_data,fs,FM_chirp,CFFM_chirp,weight)
%
%   This function is a helper function for the find chirps algorithm that
%   is used to analyze the bat data to find the chirps that have been
%   detected by the microphones. This uses the time domain signal that has
%   been collected by the array. This compares the CFFM chirp from actual
%   data to the filtered dataset. 
%
%   Sam Kramer
%   August 1st, 2023

% --Cross correlate vs. simple chirps
    [FM_corr, ~] = xcorr(filtered_data, FM_chirp);
    [CFFM_corr, ~] = xcorr(filtered_data, CFFM_chirp);

% --Reformat data to find just the single sided cross correlation
    CFFM_corr = CFFM_corr(floor(length(CFFM_corr)/2):length(CFFM_corr));
    FM_corr = FM_corr(floor(length(FM_corr)/2):length(FM_corr));

% --Develop peak threshold criteria
    CFFM_corr = abs(CFFM_corr);
    FM_corr = abs(FM_corr);
    CFFM_peak_threshold = max(CFFM_corr) - 2*mean(CFFM_corr);
    FM_peak_threshold = max(FM_corr) - weight*mean(FM_corr);
    
% --Find peaks of both correlations
    CF_ind = five_peak_finder(CFFM_corr, CFFM_peak_threshold);
    FM_ind = five_peak_finder(FM_corr, FM_peak_threshold);

% --Compare the peaks of both {Calls Comparison Function}
    indeces = [CF_ind; FM_ind]./fs;
    time_indeces = compare_function(indeces, 0.01);

end