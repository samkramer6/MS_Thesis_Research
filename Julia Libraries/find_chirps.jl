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
    using .library

######################### Setup Section ########################

# --Load in dataset
    file_path = "C:\\Users\\Sam Kramer\\Desktop\\Engineering\\IRES 2023\\IRES 2023 -- Acoustics Array\\Test Data\\Testing 20JUL23\\Bat1_Trial2_20JUL2023.mat";
    
    data = matread(file_path);
    data = data["final_output_data"];

    mic_data = data[2:end - 1, 2:end];
    time = vec(data[2:end - 1, 1:end]);
    fs = round(1/(time[10] - time[9]));

    print("Loaded Data Successfully")

# --