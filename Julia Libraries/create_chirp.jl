#=  create_chirp()
    This is a function that will create a chirp that can be used for the time domain finder
    algorithm. This uses the chirp function from the DSP package.

    Inputs:     chirp_type::string  ==  linear or log scaling
                freq_start::int     ==  Start frequency of chirp (Hz)
                freq_end::int       ==  End frequeny of chirp (Hz)
                fs::int             ==  Sample frequency from test (Hz)
                show_chirp::bool    ==  option to show chirp
                show_spect::bool    ==  option to show spectrogram
                number::int         ==  number of chirps per second

    Sam Kramer
    September 5th, 2023
=#

# --Include statements


# --Using Statements
    using SignalAnalysis
    using GLMakie
    using DSP 


# --Function definition
function create_chirp(freq_start, freq_end, duration, fs, show_response)

# --Generate chirp signal
    chirp_signal = chirp(freq_start, freq_end, duration, fs);   # Call chirp function
    chirp_signal = convert(Vector, chirp_signal);               # convert from MetaArray into a complex vector
    chirp_signal = real(chirp_signal);                          # Convert into a real array.

# --Show plots of signals, will default to false

        if show_response == "true"
            t = vec(0:1/fs:duration - (1/fs));

            scene1 = lines(t, chirp_signal, xlabel = "Time (s)", ylabel = "Amplitude", title = "Generated Chirp Signal");

            spec = spectrogram(chirp_signal, 300, 290, fs = fs);
            y = Plots.heatmap(spec.time, spec.freq, spec.power, xlabel = "Time (s)", ylabel = "Frequency", title = "Spectrogram", color = :jet)
            display(y)

        end

    return chirp_signal
end
