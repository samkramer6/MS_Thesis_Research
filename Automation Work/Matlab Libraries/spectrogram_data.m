function spectrogram_data(data_path,mic_num,time_start,time_end,type)
%
%   This function will be used to find the spectrogram of the data once a
%   test has been completed. This will be for finding the resonant
%   frequencies of the microphone data and confirming there is no noise
%   pollution into the data. There are options to have it in log or linear
%   scales
%
%   Inputs:     
%       data_path::AbsStr   ==  The path that points to the dataset
%       mic_number::Int     ==  The microphone you would like to 
%                               investigate the data from.
%       time_start::Float   ==  The time window starting point.
%       time_end::Float     ==  The time window ending point. Will default
%                               to whole dataset if left out.
%       type::AbsStr        ==  The type of scale you would like the
%                               spectrograms to be in ("Log" or "Linear").
%
%   Sam Kramer
%   June 30th, 2023
%   
%   See also load_data and spectrogram_function
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

% --Finding Spectrogram
    type = upper(string(type));
    try
        if type == "LOG"
            spectrogram_function_dB(data,fs,time_start,time_end)
        elseif type == "LINEAR"
            spectrogram_function(data,fs,time_start,time_end)
        end

    catch
        disp("Could not create spectrogram")
    end

end