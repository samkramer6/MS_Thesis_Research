#=  law_of_large_numbers.jl

This will be the simulation file for the simple law of large numbers simulation that is going to
be used to show that as n samples increases the distribution of a random sample trends to the
statistical mean

    Sam Kramer
    July 1st, 2024
=#

using StatsPlots
using Distributions
using Plots
gr()

mutable struct population
    members::Vector{Float64}
    mean::Float64
    num_members::Int64
    population() = new()
end

function populate(Pop::population, N::Int64)

    Pop.members = rand(Normal(0, 1), N)
    Pop.num_members = N
    Pop.mean = abs.(mean(Pop.members))

    return Pop::population
end

function main()

    num_iterations = 100
    num_N = 1000

    N = exp10.(range(log10(1), log10(1000000), num_N))
    solution2 = zeros(num_iterations, num_N)

    for j in collect(range(1, num_iterations))

        solution::Vector{Float64} = vec([])

        for i in collect(1:length(N))
            pop = populate(population(), round(Int64, N[i]))
            append!(solution, pop.mean)
        end

        solution2[j, :] = solution

    end

    plot(
        N,
        vec(mean(solution2, dims = 1)),
        xaxis = :log,
        xlabel = "Number Iterations (N)",
        ylabel = "Mean Absolute Value |μ|",
        title = "Behaviour of Random Values",
        label = false,
        ylim = (0, 1),
        guidefont = "Computer Modern",
        titlefont = "Computer Modern",
        tickfont = "Computer Modern",
    )

    savefig("result.png")

    pop = populate(population(), 1000)
    histogram(
        pop.members,
        bins = 40,
        xlabel = "Value",
        ylabel = "Occurance",
        title = "Histogram of Population",
        label = false,
        guidefont = "Computer Modern",
        titlefont = "Computer Modern",
        tickfont = "Computer Modern",
    )

    savefig("Population Histogram.png")
    
    return nothing
end

main()
