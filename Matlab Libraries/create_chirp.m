function signal = create_chirp(chirp_type, number, length, freq_start, freq_end, fs, show_spect)
%{
    This function will be used to create a chirp signal that will be used
    for the advanced filtering of the signals that are returned from the
    bat recordings.

    Inputs:     chirp_type  == linear or logarithmic, takes a string
                freq_start  == Start frequency of chirp  (Hz)
                freq_end    == Ending frequency of chirp (Hz)
                fs          == Sample frequency (Hz)
                show_chirp  == option to show chirp boolean
                show_spect  == option to show spectrogram bool
                number      == number of chirps per second
                

    Sam Kramer
    July 11th, 2023
%}

% --Call on the dsp.chirp function
    number = length/number;
    chirp = dsp.Chirp('SweepDirection', 'Unidirectional', ...
                      'Type', chirp_type, ...
                      'TargetFrequency', freq_end, ...
                      'InitialFrequency', freq_start,...
                      'TargetTime', number, ...
                      'SweepTime', number, ...
                      'SamplesPerFrame', length*fs, ...
                      'SampleRate', fs);

% --Output Signal
    signal = chirp();

% --Show Spectrogram
    if show_spect == "True" || show_spect == "true"
        try
            spectrogram_function(signal,fs,0,length)   % My own function

            disp("Chirp Created")
        catch
            [s,f,t] = spectrogram(signal, hamming(300), 290, [], fs,'yaxis');
                s = 20*log10(abs(s));
                s = s - max(s);
                imagesc(t,f,s)
                set(gca,"YDir","normal")
                colormap('jet')
                clb = colorbar;
                clim([-60 0])
                title('Unfiltered Spectrogram of Data')
                xlabel('Time (s)');
                ylabel('Frequency (Hz)')
                clb.Title.String = "Power (dB)";
                ylim([30000 max(f)])

            disp("Default Spectrogram Settings Used")
        end

    end

end