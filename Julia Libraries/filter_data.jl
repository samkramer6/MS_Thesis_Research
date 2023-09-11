#=  filter_data()
    This is the inclusion of the data filter function that will be used to filter out the datasets
    before passing them into the domain finder algorithms. 

    Sam Kramer
    September 10th, 2023
=#

# --Using statements
    using DSP
    using Main.library

function filter_data(data, fs)

    # --Filter Parameters
        filter_order = 4;           # Change this to see differences in responses
        filter_center = 100000;
        filter_width = 0.6;
        filter_upper = filter_center + filter_center*filter_width;
        filter_lower = filter_center - filter_center*filter_width
       
    # --Design filter
        response_type = Bandpass(filter_lower, filter_upper, fs = fs);
        design_method = Butterworth(filter_order); 
        
    # --filter Data
        filtered_data = filt(digitalfilter(response_type, design_method), data);

    return filtered_data
end