#   helper_functions.jl

using DSP
using FFTW 
using Distributions
using Plots
  gr()

###################################################################################################

mutable struct Data

    signal::Any    
    long_signal::Any
    ref_signal::Any 
    noise::Any
    noisy_signal::Any 
    fs::Int64
    SNR::Any

end

struct Corr

    signal::Vector{Float64}
    noisy_signal::Vector{Float64}
    correlation::Vector{Float64} 

end

struct Detection

    peak_location::Float64
    detection::BitVector
    SNR::Float64

end

###################################################################################################

function populate_signal!(data::Data)

    T = 1;
    f = vec(collect(range(10, 128, data.fs))) .* 2 .* π;
    time = vec(collect(range(0, T, data.fs)));
    hann_window = sin.(π .* time) .^ 2;
    signal::Vector{Float64} = vec(hann_window .* sin.(f .* time));

    # --Long signal
    signal_long::Vector{Float64} = vec( vcat( vcat(zeros(data.fs, 1), signal), zeros(data.fs, 1) ) ); 
    
    # --Reference signal
    signal_ref::Vector{Float64} = vec( vcat( vcat(signal, zeros(data.fs, 1)), zeros(data.fs, 1) ) ); 

    # --Store in data struct
    data.signal = signal;
    data.long_signal = signal_long;
    data.ref_signal = signal_ref; 
    
end

@inline function find_SNR!(data::Data)

    # --Find noise and signal power
    @fastmath noise_power = sum(data.noise .^ 2) ./ length(data.noise)
    @fastmath signal_power = sum(data.signal .^ 2) ./ length(data.signal)

    # --Calculate SNR
    @fastmath SNR::Float64 = round.(10 .* log10.(signal_power ./ noise_power), digits = 3);
    data.SNR = SNR;

end

@inline function populate_noise!(data::Data, α, β)

    # --Create noise vector
    noise::Vector{Float64} = α .* vec(rand(Normal(0, 0.33), 1, length(data.long_signal))) ./ β

    # --Create noisy signal
    noisy_signal::Vector{Float64} = data.long_signal .+ noise; 

    # --Save to struct
    data.noise = noise;
    data.noisy_signal = noisy_signal;

    # --find SNR
    find_SNR!(data);

end

@inline function populate_noise_colored!(data::Data, α, β)

    # --Create noise vector
    noise::Vector{Float64} = α .* vec(rand(Normal(0, 0.33), 1, length(data.long_signal))) ./ β

    # --Filter noise vector to make colored noise
        a = vec(zeros(1, 255));
        a[1] = 1;
        i = collect(range(2, length(a)));
        a[i] = (0.3 .+ i .- 1) .* (a[i .- 1] ./ i);
        filter_design = DSP.PolynomialRatio(vec(a), vec([1]));

    # --Color the noise
        noise = DSP.filt(filter_design, noise);

    # --Create noisy signal
    noisy_signal::Vector{Float64} = data.long_signal .+ noise; 

    # --Save to struct
    data.noise = noise;
    data.noisy_signal = noisy_signal;

    # --find SNR
    find_SNR!(data);

end

@inline function detect_signal(data::Data, known_location::Int64, algorithm::String)
    
    # --Find correlation
    if algorithm == "Cross-Correlation"
        corr_out = xcorr(data);
    elseif algorithm == "Matched Filter"
        corr_out = matched_filter(data);
    end
    
    # --Find peak location
    max_location = findall(x -> x == 1, corr_out.correlation);
    # @show abs.(max_location .- known_location) .<= 100 
    
    # --Store into struct
    detection_output = Detection(max_location[1], (abs.(max_location .- known_location) .<= 100), data.SNR); 
        
    return detection_output::Detection
end

@inline function roll_dice(data::Data, α, β, algorithm::String, noise::String)

    # --Populate Noise Function
    if noise == "White"
        populate_noise!(data, α, β);
    elseif noise == "Red"
        populate_noise_colored!(data, α, β)
    end
    
    # --Detect location of signal
    detection_output::Detection = detect_signal(data, data.fs, algorithm);

    return detection_output::Detection 
end

@inline function find_pdf(SNRs::Vector{Float64}, Probabilities::Vector{Float64})

    derivative = vec(zeros(1, length(SNRs) - 1));

    for i in collect(range(1, length(SNRs)-1))
        
        num = Probabilities[i + 1] - Probabilities[i];
        denom = SNRs[i + 1] - SNRs[i];
        
        derivative[i] = num ./ denom;
    
    end
    
    return derivative::Vector{<:Number}
end
###################################################################################################

@inline function xcorr(data::Data)
    
    # --Find correlation
    corr::Vector{Float64} = vec(abs.(ifft( fft(data.noisy_signal) .* conj.(fft(data.ref_signal)) )));
    @fastmath corr = corr ./ maximum(corr);

    # --Store in a new struct which is returned
    output = Corr(data.signal, data.noisy_signal, corr);

    return output::Corr
end

@inline function matched_filter(data::Data)

    # --Generate filter
    filter_design = PolynomialRatio(reverse(data.signal), vec([1]));
    
    # --Filter data
    matched_output::Vector{Float64} = vec(filt(filter_design, data.noisy_signal)); 
    @fastmath matched_output = reverse(matched_output ./ maximum(matched_output));
    
    # --Store in a new struct
    corr = Corr(data.signal, data.noisy_signal, matched_output);

    return corr::Corr
end

# End File
