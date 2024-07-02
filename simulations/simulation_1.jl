#=  simulation_1.jl

    This is the simulation script that I will be running for some of the updated simulations for
    my thesis research. Primarily what will be done is the simulations for the paper that I will
    publish in a paper.

    Scope:
        - This is only going to focus on some of the algorithms and will only contain 1 type of
          noise and one type of signal.

    Sam Kramer
    May 27th, 2023
=#

using Plots
using Distributions
using FFTW
using SignalAnalysis

###################################################################################################
#                                           Function Declarations                                 #
###################################################################################################

# --Generate Noise Function
function generate_noise(len::Int64, α::Float64, β::Float64)

    # --Generate Noise Vector
    noise = α .* vec(rand(Normal(0, 0.33), 1, len)) ./ β

    return noise::Vector{Float64}
end

# --Calculate SNR
function find_SNR(signal::Vector{Float64}, noise::Vector{Float64})

    # --Find noise and signal power
    noise_power = sum(noise .^ 2) ./ length(noise)
    signal_power = sum(signal .^ 2) ./ length(signal)

    # --Calculate SNR
    SNR = 10 .* log10.(signal_power ./ noise_power)
    SNR = round.(SNR, digits = 3)

    return SNR::Float64
end

# --Generate Noisy Data
function generate_noisy_signal(
    signal::Vector{Float64},
    long_signal::Vector{Float64},
    α::Float64,
    β::Float64,
)

    # --create noise vector
    @inline noise_vector = generate_noise(length(long_signal), α, β)

    # --Create noisy signal
    noisy_signal = noise_vector .+ long_signal
    noisy_signal = noisy_signal .- mean(noisy_signal)

    # --Find SNR
    @inline SNR = find_SNR(signal, noise_vector)

    return noisy_signal::Vector{Float64}, SNR::Float64
end

# --Correlation Function
function xcorr(data::Vector{Float64}, ref::Vector{Float64})

    # --FFT all data into frequency domain
    f_data = fft(data)
    f_ref = fft(ref)

    # --Find correlation of the data
    corr = abs.(ifft(f_data .* conj(f_ref)))
    corr = corr ./ maximum(corr)

    return corr::Vector{Float64}
end

# --Detection Return function
function positive_detection(
    corr::Vector{Float64},
    fs::T where {T<:Real},
    known_location::Int64,
)

    # --Test if peak is in the right spot
    max_location = findall(x -> x == 1, corr)

    return (abs.(max_location .- known_location * fs) .<= 1000)
end

# --Actual Simulation Function
function Monte_Carlo_Simulation(signal, long_signal, reference, α, β, fs, known_location)

    # --Generate Noisy signal
    @inline (noisy_signal, SNR) = generate_noisy_signal(signal, long_signal, α, β)

    # --Calculate correlation
    @inline correlation_output = xcorr(noisy_signal, reference)

    # --Find detection result
    @inline result = positive_detection(correlation_output, fs, known_location)

    return SNR::Float64, result::Bool
end

###################################################################################################
#                                              Main Body                                          #
###################################################################################################



