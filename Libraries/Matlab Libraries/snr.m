function snr(data, ref)
%
%   This is a function that will be able to calculate the SNR of a data set
%   and print it.
%
%   Sam Kramer
%   January 20th, 2024

    % --Finding the power of reference signals
        signal_power = sum(ref.^2)/(2*length(ref) + 1);

    % --Calculate the noise power
        ref_signal = zero_pad(data, ref);
        noise = data - ref_signal;
        noise_power = sum(noise.^2)/(2*length(noise) + 1);

    % --Calculate SNR and output 
        SNR = 10*log10(signal_power/noise_power);

    % --Print it out
        fprintf("The SNR for the signal is %3.3f \n",SNR)

end