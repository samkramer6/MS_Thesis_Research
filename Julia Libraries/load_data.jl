#=  load_data()
    This is the load data function that is used to load any data that a user wants to analyze. 
    This uses one package and is a very basic function that is used multiple times in the find
    chirps functions.

    Sam Kramer
    August 10th, 2023
=#

using MAT

function load_data(file_path)
    
    # --Load in Data
        data = matread(file_path);
        data = data["final_output_data"];

    # --Reformat Data
        mic_data = data[2:end - 1, 2:end];
        time = vec(data[2:end - 1, 1]);
        fs = round(1/(time[10] - time[9]));

    # --Outline
        println("Data Loaded Successfully")
        return mic_data, time, fs
end