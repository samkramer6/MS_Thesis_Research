function output = kxcorr(x, y, type)
% 
%   This is a function that will be used to calculate the correlations of
%   two signals, x and y. The output will be the correlation output.
%
%   Inputs:
%       x::array[Float64]   --  The original signal data that has noise
%       y::array[Float64]   --  The reference signal with no noise
%       type::String        --  The selection of kernel function
%
%   Outputs:
%       output::array[Float64] -- The correlation output of the signals
%
%   Sam Kramer
%   January 20th, 2024

    % --Zero Pad Data
        y = zero_pad(x, y);

    % --Kernels of data
        type = upper(type);
        if type == "CUBIC"

            kx = cubic_kernel(x, x);
            ky = cubic_kernel(y, y);

        elseif type == "LABS"

            kx = Labs_kernel(x, x);
            ky = Labs_kernel(y, y);

        elseif type == "RBF"

            kx = rbf_kernel(x, x);
            ky = rbf_kernel(y, y);

        end

    % --Fourier Transforms of kernels
        kx_hat = fft(kx);
        ky_hat = fft(ky);

    % --Define Training set
        g_hat = ones(1, length(ky_hat));

    % --Create correlation output
        corr_hat = kx_hat .* conj(g_hat .* ky_hat);
        corr = ifft(corr_hat);
        corr = corr - min(corr);
        output = corr ./ max(corr);

end

%%%%%%%%%%%%%%%%%%%%% Helper Function Definitions %%%%%%%%%%%%%%%%%%%%%%%%%

function kf = cubic_kernel(x, y)

    % --Find kernel
        kf = (x.*y + 1).^3;

end

function kf = Labs_kernel(x, y)

    % --Find the kernel
        kf = abs(x + y);

end

function kf = rbf_kernel(x, y)
        
    % --Parameters
        sigma = 0.3;

    % --Find kernel
        kf = exp(-1.*(x.^2 + y.^2) ./ (2*sigma));

end