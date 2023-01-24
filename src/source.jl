abstract type InformationSource end

struct DiscreteMemorylessSource{T} <: InformationSource
    symbols::Vector{T}
    distribution::Vector{Float64}
    entropy::Float64
end

function DiscreteMemorylessSource(distribution::Vector{Float64}; symbols=nothing, normalize=true)
    n = length(distribution)
    !isnothing(symbols) || symbols = collect(1:n)
    normalize || distribution /= sum(distribution)
    return DiscreteMemorylessSource{Integer}(
        collect(1:n),
        distribution,
        entropy(distribution))
end