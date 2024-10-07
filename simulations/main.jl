# This is the main document for the simulation

include("helper_functions.jl")

using BenchmarkTools
using Plots
gr()
using Timers
using PlotThemes
using HDF5

function main(algorithm::String, noise::String)

    # --Parameters
    println("Starting Simulations")
    α = range(2.0, 151.0, 100)
    num_points = length(α)
    β = range(7.5, 0.1, num_points)
    num_sims = 10000
    SNRs::Vector{Float64} = vec(zeros(Bool, 1, length(α)))
    Probabilities::Vector{Float64} = vec(zeros(Float64, 1, length(α)))
    Timers.tic()

    # --Populate Signal
    data = Data((), (), (), (), (), 1024, ())
    populate_signal!(data)

    # --Outer for loop (SNR loop)
    for i in collect(range(1, length(α)))

        detection_result::BitVector = BitVector(undef, num_sims)
        SNR_result::Vector{Float64} = vec(zeros(Float64, 1, num_sims))

        for j in collect(range(1, num_sims))

            detection_output::Detection = roll_dice(data, α[i], β[i], algorithm, noise)

            @inbounds SNR_result[j] = detection_output.SNR
            @inbounds detection_result[j] = detection_output.detection[1]

        end

        @inbounds SNRs[i] = mean(SNR_result)
        @inbounds Probabilities[i] = mean(detection_result)

    end

    # --Plot
    plot!(SNRs, Probabilities,
        xlims=(-55, 5),
        ylims=(0, 1.05),
        label="$algorithm - $noise",
        # label="Detection Probability",
        guidefont="Computer Modern",
        xlabel="SNR (dB)",
        # ylabel = "Detection Probability",
        tickfont="Computer Modern",
        linewidth=1.5,
        legendfont="Computer Modern",
        theme=:bright,
        dpi=500,
    )

    # --Finding Numerical PDF
    numerical_pdf = find_pdf(SNRs, Probabilities)

    plot!(SNRs[1:end-1], numerical_pdf,
        label="Numerical PDF",
        linewidth=1.5,
    )

    # --PDF Fitting
    k = 80       # Shape Parameter
    λ = 21       # Scale Parameter
    x = collect(range(1, 130, length(numerical_pdf)))
    xaxis = collect(range(-55, 5, length(x)))
    pdf_fit = 1.6 .* (λ / k) .* (((x) ./ k) .^ (λ - 1)) .* exp.(-((x) ./ k) .^ λ)

    plot!(xaxis, pdf_fit,
        label="PDF Fit",
        linewidth=1.5,
    )

    # --K-S Testing for fit
    ks_result = ks_test(numerical_pdf, pdf_fit)

    # --Out Statement
    num_total_sims = num_points * num_sims
    println("====== SIM DONE ======")
    println("Algorithm Used: $algorithm")
    println("Noise Type Used = $noise")
    println("sims per point = $num_sims")
    println("K-S Results are $ks_result")
    println("Total Sims = $num_total_sims\n")
    Timers.toc()
    println("\n")

    # --Save as .HDF5 file
    # h5write("pdf_data.h5", "pdf_data", numerical_pdf)

end

plot()
main("Cross-Correlation", "White")
# main("Matched Filter", "White")
# main("Cross-Correlation", "Red")
# main("Matched Filter", "Red")
# savefig("MF_weibull_fit.pdf")

