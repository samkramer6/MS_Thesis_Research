function specfilt_data(data_path,mic_num,time_start,time_end,filt_center)
%
%   This function will be used to find the spectrogram of the data once a
%   test has been completed. This will filter out noise from the system and
%   will be able to analyze tests properly to find chirp data. This has set
%   filter settings that cannot be changed unless the code is adjusted. The
%   center is adjustable but has a default of 80kHz, and has a width of 
%   0.25. This will be in the linear scale due to the usefulness of the 
%   linear spectrograms when filtered.
%   
%   Inputs:     
%       data_path::AbsStr   ==  The path that points to the dataset
%       mic_number::Int     ==  The microphone you would like to 
%                               investigate the data from.
%       time_start::Float   ==  The time window starting point.
%       time_end::Float     ==  The time window ending point. Will default
%                               to whole dataset if left out.
%       filt_center::Int    ==  The filter center that you desire. Will
%                               default to 80kHz.
%
%   Sam Kramer
%   August 4th, 2023
%   
%   See also filter_data, spectrogram_data, and spectrogram_function
%

% --Load in data
    [data,~,fs] = load_data(data_path);

% --Select microphone of interest
    mic_num = uint8(mic_num);           % Confirms int data type
    try
        data = data(:,mic_num);
    catch
        disp("Mic does not exist in dataset")
    end

% --Filter data
    try
        try 
            filtered_data = filter_data(data,fs,filt_center,0.25,"False");
        catch
            filtered_data = filter_data(data,fs,80000,0.5,"False");
        end
    catch
        fprintf("Issue Filtering Data \n");
        filtered_data = data;
    end

% --Finding Spectrogram
    spectrogram_function(filtered_data,fs,time_start,time_end)
    
end