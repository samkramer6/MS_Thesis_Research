#=  compare_function()
    This is a function that is used to compare the time indeces of the peaks for a single dataset 
    vector. It will eliminate any repeated values and will also eliminate any values that are 
    within a certain threshold of eachother. Will return a new vector as new_ind.

    Inputs:
        Indeces::AbsVec =   This is a data vector that you would like to compare the data and eliminate all the reapeated values.
        threshold::Float =  This is the difference threshold criteria you establish to eliminate two values and combine them to a single value. 

   Ouputs:
           new_ind::AbsVec =   This is a new vector with a compare dataset that keeps the unique values.

    Sam Kramer
    September 14th, 2023
=#

# --Create another while function to remove the nested loops below
function while_indeces(indeces, new_ind, threshold, i)

    # --Loop through each value of the indeces
        okay = "true"
        IIQ = indeces[i];
        k = 1;
        while k <= length(new_ind)

            # --Check difference
                diff_ind = abs.(new_ind[k] - IIQ);

            # --If difference is enough, continue
                if diff_ind >= threshold
                    k = k+1;
                else
                    okay = "false";
                break
                end
        end

    # --Save value into new_ind
        if okay == "true"
            new_ind = [new_ind; IIQ];
        end

    return new_ind
end

# --Function Definition
function compare_function(indeces, threshold)

    # --Setup
        new_ind = [indeces[1]];

    # --Loop through entire indeces array set
        for i = 2:length(indeces)

            # --Call while_indeces
                new_ind = while_indeces(indeces, new_ind, threshold, i);
        end

	# --Sort new_ind
        new_ind = sort(new_ind);
    
    return new_ind
end