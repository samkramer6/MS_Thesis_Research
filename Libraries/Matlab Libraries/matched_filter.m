function matched_output = matched_filter(x, y)
%
%   This function is the construction of the matched filter for the signals
%   x with a reference y. The output will be a matched filter output
%   similar to a correlation. Any spikes indicate a correlation to the
%   system.
%   
%   Sam Kramer
%   January 20th, 2023


    % --Flip reference signal
        b = conj(fliplr(y));

    % --Call filter function
        matched_output = filter(b, 1, x);

    % --Normalized output
        output = matched_output - mean(matched_output);
        matched_output = output ./ max(output);

end