function find_chirps(data_path,mic_num,bat_type)
%   
%   This is a function that will systematically create a spectrogram of the
%   chirps that are detected from a specific dataset that is passed to the
%   function. This uses a filtered dataset for the time_domain_finder and
%   an unfiltered dataset for the frequency domain finder. Both sections do
%   not output filtered spectrograms, only unfiltered spectrograms are
%   used. 
% 
%   Sam Kramer
%   July 28th, 2023
%

%%%%%%%%%%%%%%%%%%%%%%%%%% Selecting Data Type %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --Workspace messages
    clc; warning off;

% --Load in data
    [data,~,fs] = load_data(data_path);
    disp("Loaded data successfully.")

% --Select Microphone out of data
    mic_num = uint8(mic_num);
    data = data(:,mic_num);

% --Select Bat type
    bat_type = string(bat_type);
    bat_type = char(upper(bat_type));
    try
        if bat_type(1) == 'H'
            % --Load in hippo call
                hippo_call = load("Hippo_example_chirp.mat");
                CFFM_chirp = hippo_call.model_chirp;
                disp("Selected Hipposideros")

            % --create linear chirp pattern
                FM_chirp = create_chirp("Linear",1,1,120000,100000,500000,"false");
                weight = 1.3;

        elseif bat_type(1) == 'R'
            % --Load in rhino calls
                rhino_call = load("Rhino_example_chirp.mat");
                CFFM_chirp = rhino_call.model_chirp;
                FM_chirp = create_chirp("Linear",1,1,120000,100000,500000,"false");
                weight = 0;
        end
    catch
        % --Error handler
            disp("No example chirp selected")
            disp("Checking only on a linear chirp pattern")

        % --create linear chirp pattern
            FM_chirp = create_chirp("Linear",1,1,120000,100000,500000,"false");
    end

% --Feedback message
    fprintf("Finding Chirps...\n")
    fprintf("This may take a moment.\n")

% --Filter data for correlations
    try
        filtered_data = filter_data(data,fs,100000,0.6,"false");
    catch
        filtered_data = filter_data(data,fs,[],[],"false");
            disp("Error with filter")
            disp("Ensure that Nyquist is above 200kHz")
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%% Time Domain Section %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ghost Code:
    % --Compare the two time domain signals {Call time_domain_finder()}
        time_indeces = time_domain_finder(filtered_data,fs,FM_chirp,CFFM_chirp,weight);
        
    % --Outline for time domain section
        fprintf("Time Domain Finder Done.\n")
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Freq Domain Section %%%%%%%%%%%%%%%%%%%%%%%%%%

% Ghost Code:
    % --Compare two frequency domain signals {Call freq_domain_fnder()}
        
    
    % --Outline for time domain section
        fprintf("Frequency Domain Finder Done.\n")

%%%%%%%%%%%%%%%%%%%%%%%%%%% Output Spectrograms %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ghost Code:
    % --Compare the two finder indeces


     % --Make new directory
        if ~exist("C:\Users\FIT UBD\Desktop\Data Analysis Spectrogram Files\","dir")
            cd("C:\Users\FIT UBD\Desktop")
            mkdir("Data Analysis Spectrogram Files")
            cd("C:\Users\FIT UBD\Desktop\Data Analysis Spectrogram Files")
        else
            cd("C:\Users\FIT UBD\Desktop\Data Analysis Spectrogram Files\")
        end

    % --Generate Spectrograms
        for i = 1:length(time_indeces)
            
            % --Call on spectrogram_function
                spect = figure('Visible','off');
                spectrogram_function(filtered_data,fs,time_indeces(i) - 0.021, time_indeces(i) + 0.021);

            % --Create title
                title = "Spectrogram" + string(i) + ".jpg";

            % --Save spectrogram of data
                saveas(spect,title)
                
        end

    % --Close out of the directory
        cd("C:\Users\FIT UBD\Desktop")
        fclose("all");
        close all;          % Close all the open figures
end

