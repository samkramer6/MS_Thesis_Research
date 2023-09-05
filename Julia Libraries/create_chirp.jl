#=  create_chirp()
    This is a function that will create a chirp that can be used for the time domain finder
    algorithm. This uses the chirp function from the DSP package.

    Inputs:     freq_start::int     ==  Start frequency of chirp (Hz)
                freq_end::int       ==  End frequeny of chirp (Hz)
                fs::int             ==  Sample frequency from test (Hz)
                show_response::bool ==  option to show chirp

    Sam Kramer
    September 5th, 2023
=#

# --Using Statements
    using SignalAnalysis
    using DSP
    using Plots 

# --Function definition
function create_chirp(freq_start, freq_end, duration, fs, show_response)

# --Generate chirp signal
    chirp_signal = chirp(freq_start, freq_end, duration, fs);   # Call chirp function
    chirp_signal = convert(Vector, chirp_signal);               # convert from MetaArray into a complex vector
    chirp_signal = real(chirp_signal);                          # Convert into a real array.

# --Show plots of signals, will default to false
        if show_response == "true"

            # --Create spectrogram of response
                spec = spectrogram(chirp_signal, 300, 290, fs = fs);
                y = Plots.heatmap(spec.time, spec.freq, spec.power, xlabel = "Time (s)", ylabel = "Frequency", title = "Spectrogram", color = :jet)

        end

# --Display plot if it exists
    try
        display(y)
    catch
    end

    return chirp_signal 
end
