function [data,time,fs] = load_data(data_path)
%
%   This function is used to properly format and load the data set pulled
%   from the app quickly. It will return three things of type double. The
%   data is the data matrix, the time is the time vector and the fs is the
%   sample rate of the data.
%
%   Sam Kramer
%   July 26th, 2023

% --Setup
    acoustic_data = "data";     % Place holder variable

% --Load in data from data path
    try
        load(data_path);
    catch
        fprintf("Data could not load properly, make sure path is correct \n")
    end

% --If data is a time table
    if class(acoustic_data) == "timetable"
        try
            time = acoustic_data.Time;
            time = seconds(time);
            data = acoustic_data.Dev1_ai0;
            fs = round(1/(time(10)-time(9)));
        catch
            fprintf("This function does not work on timetable objects\n")
            fprintf("Try using a load_time_table function\n")
        end
    else
        try 
            % --Formatting a double array type
                final_output_data = final_output_data(2:end-1,:);
                data = final_output_data(:,2:width(final_output_data));
                time = final_output_data(:,1);
                fs = round(1/(time(10)-time(9)));
        catch
            fprintf("Could not format data properly \n")
        end
    end
end