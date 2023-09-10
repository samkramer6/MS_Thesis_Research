#=  find_chirps()
    This is the main find chirps function that is going to be run to structure the algorithm within
    julia. This is going to be largely based on the matlab function that I have made but in a
    faster more flexible programming language. 

    Sam Kramer
    August 30th, 2023

=#

# --Include statements
    include("library_module.jl")

# --Using Statements
    using GLMakie
    using FFTW
    using SignalAnalysis
    using MAT

# --module inclusion
    using Main.library

############################################ Parameters ###########################################
    file_path = "C:\\Users\\Sam Kramer\\Desktop\\Engineering\\IRES 2023\\IRES 2023 -- Acoustics Array\\Test Data\\Testing 20JUL23\\Bat1_Trial2_20JUL2023.mat";
    mic_num = 1;
    bat_type = "Hipposiderus";

########################################## Setup Section ##########################################

# --Load in dataset and select mic dataset
    (mic_data, time, fs) = load_data(file_path);
    mic_data = vec(mic_data[:, mic_num]);

# --Select Bat Call Comparison
    bat_type = String(bat_type);
    bat_type = uppercase(bat_type);

    try
        if bat_type[1] == 'H'
            # --Load in Hipposiderus call


        elseif bat_type[1] == 'R'
            # --Load in Rhinolophus call


        else
            # --Load in only FM_chirp


        end
    catch
        # --Load in only FM_chirp



    end

# --Feedback message
    println("Chirp Finder Beginning")
    println("This May Take a Moment...")


# --Filter data out {Calls filter_data()}


####################################### Time Domain Section #######################################

# --Create initial guesses in time domain {Calls time_domain_finder()}


# --Outline confirmation message
    println("Time Domain Finder Done")

####################################### Freq Domain Section #######################################

# --Create guesses from frequency domain methods {Calls freq_domain_finder()}


# --Outline confirmation message
    println("Frequency Domain Finder Done")

####################################### Create Spectrograms #######################################

# --Compare datasets


# --

