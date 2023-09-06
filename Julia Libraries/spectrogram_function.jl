#= spectrogram_function()
    This is a function that is meant to take a spectrogram of any input data that is passed to the function.
    This will output a single spectrogram and is modelled off the matlab version.

    Sam Kramer
    August 30th, 2023

=#

# Using statements
    using Plots
    using DSP    # Signal Processing Package for spectrogram()
    using Statistics

function spectrogram_function(data, fs, time_start, time_end)

    # --Maniupulate the dataset
        try

            # --Find ind = 1
                ind1 = time_start*fs + 1;
                ind2 = time_end*fs;

            # # --Pull in dataset
                data = data[(ind1):(ind2)];
                data = data .- mean(data);
                i = "true";

        catch 

            i = "false";
            println("Error: Displaying Whole Time Set")
            data = data .- mean(data);

        end

    # --Creating the spectrogram
        spec = spectrogram(data, 300, 290, fs = fs);
            
    # --Reformat time
        time = spec.time;
        N = length(time);
        time = LinRange(time_start, time_end, N);       # linspace equivalent

    # # --Create Heatmap
        y = Plots.heatmap(time, spec.freq, spec.power, xlabel = "Time (s)", ylabel = "Frequency (Hz)", title = "Spectrogram", colorbar_title = "Power (Linear)", color = :jet);
        # colorbar(y, label = "Power (Linear)")
        display(y)

    return
end