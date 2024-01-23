function [white_signal, brown_signal, reference, ref_chirp_long] = generate_signals(alpha, beta)
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
        reference = reference';

    % --Zero padding
        time = 0:1/fs:10;
        zero_pad = zeros(1,(length(time) - length(t))/2);
        ref_chirp_long = [zero_pad, reference, zero_pad];

    % --Generate noise
        
        % --White Noise
            white_data = randi(100, 1, length(ref_chirp_long)) ./ alpha;
            white_data = white_data - mean(white_data);

        % --Brownian Noise
            cn = dsp.ColoredNoise('brown', length(ref_chirp_long));
            brownian_data = cn();
            brownian_data = brownian_data ./ beta;
            brownian_data = [brownian_data - mean(brownian_data)]';

    % --Create entire noisy signals
        white_signal = white_data + ref_chirp_long;
        brown_signal = brownian_data + ref_chirp_long;
        
end