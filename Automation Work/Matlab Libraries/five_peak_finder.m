function ind = five_peak_finder(corr, peak_thresh)
%
%   This is a helper function for the function above and is used to pull
%   out a required number of chirps to help deal with the variation in the
%   amplitudes of the correlation peaks. This will output a minimum of
%   num_chirps chirps no matter what. 
%
%   Sam Kramer
%   August 9th, 2023

%%%%%%%%%%%%%%%%%%%% Change this setting for more %%%%%%%%%%%%%%%%%%%%%%%%%

% --setup
    num_peaks = 20;  % Higher Number makes more images

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Do not touch %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --find peaks
    [~,temp_ind] = findpeaks(corr,"MinPeakHeight",peak_thresh,"MinPeakDistance",4000);

% --Get minimum of 5 peaks
    if length(temp_ind) <= num_peaks - 1

        % --Get a new amount of peaks
            [pks, indind] = findpeaks(corr, "MinPeakHeight",3*mean(corr),"MinPeakDistance",10000);
            pks = [pks, indind];
            pks(:,1);

        % --Take the top 5
            [~,peakind] = maxk(pks(:,1),num_peaks);
            ind = zeros([num_peaks,1]);
            for i = 1:num_peaks

                % --Selecting the top values
                    ind(i,1) = pks(peakind(i),2);
            end
    else

        % --Return entire dataset
            ind = temp_ind;
            disp("number of peaks met")
    end
end