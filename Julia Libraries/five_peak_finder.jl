#=  five_peak_finder()
    This is a helper function for the time_domain_finder() function and is used to pull out a
    minimum required amount of chirps to deal with the variateion in the amplitudes of the 
    correlation peaks. this will output a minimum of int::num_chirps no matter what.

=#

# --Using statements
using FindPeaks1D

# --Function Definition
function five_peak_finder(corr::Vector{Float64}, peak_threshold::Float64)

    # --Setup
        num_peaks = 20;                     # Higher number makes more peaks
        num_peaks = round(Int,num_peaks);   # Convert to amount to guarantee an integer value

    # --Find Peaks
        temp_ind, ~ = findpeaks1d(corr, height = peak_threshold, distance = 4000);

    # --Get minimum of 5 peaks
        if length(temp_ind) <= num_peaks - 1
            
            # --Get new amount of peaks
                indind, ~ = findpeaks1d(corr);
                pks = [vec(corr[indind]) vec(indind)];      

            # --Take the top value of num_peaks
               	A = sortperm(pks[:, 1], rev = true);         
                sorted_pks = pks[A,:];
                max_num_pks = sorted_pks[1:num_peaks, 1:2];
                
            # --Selecting the top values
                ind = max_num_pks[:,2];

        else

            # --Return entire dataset
                ind = temp_ind;
                println("Number of Peaks Already Met")
        end

	# --changing to type Int
		output = floor.(Int,ind)

    return output::Vector{Int64}
end