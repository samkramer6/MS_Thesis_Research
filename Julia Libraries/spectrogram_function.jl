#= spectrogram_function()
    This is a function that is meant to take a spectrogram of any input data that is passed to the function.
    This will output a single spectrogram and is modelled off the matlab version.

    Sam Kramer
    August 30th, 2023

=#

#=
    Can use tfd() function to create either a spectrogram or a WV distribution
    Check to see which is better, this could be a significant part of the thesis, the cross-WVD selection

=#

# Include statements
    using GLMakie
    using SignalAnalysis    # Signal Processing Package
    using Statistics


function spectrogram_function(data_vector, fs, time_start, time_end)

    # --Maniupulate the dataset
    try
        # --Find ind = 1
            ind1 = time_start*fs + 1;
            ind2 = time_end*fs;

        # --Pull in dataset
            data = data_vector[ind1:ind2];
            data = data - mean(data);
            i = "true";

    catch 
        i = "false";
        error("Error: Displaying Whole Time Set");
        data = data - mean(data);
    end

    # --Creating the spectrogram function
    try
        # --Take TFD Spectrogram
            y = tfd(data, Spectrogram(nfft = 300, noverlap = 290, window = hamming));
            

    catch
        # --Display error message
        error("Error: Could not make Spectrogram")

    end

    # --Reformat time 
        try
            if i == "true"

            end
                
        catch

        end

end

