function spectrogram_function(data, fs, time_start, time_end)
%
%   This is a helper function that is only for spectrogramming a single
%   vector. This is used to save the settings for spectrograms and helps
%   the spectrogram_data, specfilt_data, specfilt_data2 functions. This
%   will have a relative time section along the x-axis. This is for non-log
%   scale spectrograms of data. These may be much cleaner than the
%   log-scale spectrograms.
%
%   Inputs:     
%       data::AbsVec    =   The data you would like to spectrogram
%       fs::Int         =   The sample frequency of the data
%       time_start::float   =   The time start of the spectrogram window
%       time_end::float     =   The time end of the spectrogram window
%
%   Sam Kramer
%   July 28th, 2023
%
%   See also spectrogram_data, specfilt_data, and specfilt_data2.

% --Setup mic_number properly

% --Manipulate the dataset for the time length
    try
    
        % --Find ind = 1
            ind1 = time_start*fs + 1;
            ind2 = time_end*fs;
        
        % --Pull in data
            data = data(ind1:ind2);
            data = data - mean(data);
            i = "true";
    catch
        i = "false";
        disp("Displaying Whole Time Set")
        data = data - mean(data);
    end

% --Create Spectrogram
    try
        [s,f,t] = spectrogram(data, hamming(300), 290, [], fs,'yaxis');
            s = abs(s);
    catch
        disp("Could not create spectrogram")
    end

% --Reformat time
    try
        if i == "true"
            t = time_start:1/fs:time_end;
        end
    catch
    end

% --Plot Image and format image
    imagesc(t,f,s)
        set(gca,"YDir","normal")
        colormap('jet')
        clb = colorbar;
        clim([0 1.5])
        title('Unfiltered Spectrogram of Data')
        xlabel('Time (s)');
        ylabel('Frequency (Hz)')
        clb.Title.String = "Power (Linear)";
        ylim([30000 max(f)])

end