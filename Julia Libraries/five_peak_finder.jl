#=  five_peak_finder()
    This is a helper function for the time_domain_finder() function and is used to pull out a
    minimum required amount of chirps to deal with the variateion in the amplitudes of the 
    correlation peaks. this will output a minimum of int::num_chirps no matter what.

=#

# --Include statements


# --Using statements


# --Function Definition
function five_peak_finder()

    # --Setup
        num_peaks = 20;                     # Higher number makes more peaks
        num_peaks = round(Int,num_peaks);   # Convert to amount to guarantee an integer value

    # --Find Peaks


    # --Get minimum of 5 peaks
        if length(temp_ind) <= num_peaks - 1
            
            # --Get new amount of peaks

            # --Take the top 5


                # --Selecting the top values

        else

            # --Return entire dataset

        end

end