function spectrogram_function_dB(data, fs, time_start, time_end)
%
%   This is a helper function that is only for spectrogramming a single
%   vector. This is used to save the settings for spectrograms and helps
%   the spectrogram_data, specfilt_data, specfilt_data2 functions. This
%   will have a relative time section along the x-axis. This is the dB
%   scale 
%
%   Sam Kramer
%   July 28th, 2023
%
%   See also spectrogram_data, specfilt_data, and specfilt_data2.

% --Manipulate the dataset for the time length
    try
    
        % --Find ind = 1
            ind1 = time_start*fs + 1;
            ind2 = time_end*fs;
        
        % --Pull in data
            data = data(ind1:ind2);
            data = data - mean(data);
    catch
        disp("Displaying Whole Time Set")
        data = data - mean(data);
    end

% --Create Spectrogram
    try
        figure()
        [s,f,t] = spectrogram(data, hamming(300), 290, [], fs,'yaxis');
            s = 20*log10(abs(s));
            s = s - max(s);
    catch
        disp("Could not create spectrogram")
    end

% --Reformat time
    try
        t = time_start:1/fs:time_end;
    catch
    end

% --Plot Image and format image
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

end