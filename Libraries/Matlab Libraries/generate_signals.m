function [white_signal, brown_signal, reference, ref_chirp_long, time, w_snr, b_snr, denoised_data] = generate_signals(alpha, beta)
%
%   This is a function that is meant to streamline the generation for the
%   different signals that 
%
%   Sam Kramer
%   January 20th, 2024

    % --Parameters  
        T = 1;
        fs = 10000;
        t = 0:1/fs:T;

    % --Generate chirp
        reference = create_chirp("logarithmic", T, T, 10, 3000, fs+1, "False");
        ref = reference';

    % --Zero padding
        time = 0:1/fs:10;
        zero_pad = zeros(1,(length(time) - length(t))/2);
        denoised_data = [zero_pad, ref, zero_pad];

    % --Generate noise
        
        % --White Noise
            white_data = randi([-1000, 1000], 1, length(denoised_data)) ./ alpha;
            white_data = white_data - mean(white_data);

        % --Brownian Noise
            cn = dsp.ColoredNoise('brown', length(denoised_data));
            brownian_data = cn();
            brownian_data = brownian_data ./ beta;
            brownian_data = [brownian_data - mean(brownian_data)]';

    % --Create entire noisy signals
        white_signal = white_data + denoised_data;
        brown_signal = brownian_data + denoised_data;

    % --Calculate the SNR values of the signals
        signal_power = sum(ref.^2)/(2*length(ref) + 1);
        w_noise_power = sum(white_data.^2)/(2*length(white_data) + 1);
        b_noise_power = sum(brown_signal.^2)/(2*length(brownian_data) + 1);

        w_snr = 10*log10(signal_power/w_noise_power);
        b_snr = 10*log10(signal_power/b_noise_power);

    % --Declare Reference Chirp of same size
        ref_chirp_long = [ref, zero_pad, zero_pad];
        
end