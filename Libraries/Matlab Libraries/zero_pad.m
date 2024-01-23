function y = zero_pad(x, y)
% 
%   This is the function for zero-padding data that is going to be used in
%   the correlation sets for the data. This is to make zero_padding
%   automated and easy to use. 
%
%   Assumptions:
%       length(x) >= length(y)
%
%   Sam Kramer
%   Jan 20th, 2024

    % --Get Lengths and differnce
        len_x = length(x);
        len_y = length(y);
        diff = len_x - len_y;

    % --Create zero_padding data set
        pad = zeros(1, floor(diff/2));
        y = [pad, y, pad];

    % --Check
        if length(x) ~= length(y)
            y = [y, 0];
        end
        
end