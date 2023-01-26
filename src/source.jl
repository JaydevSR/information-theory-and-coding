abstract type InformationSource end

struct DiscreteMemorylessSource{T} <: InformationSource where T
    symbols::Vector{T}
    distribution::Dict{T, Float64}
end

function DiscreteMemorylessSource(
                    distribution::Vector{Float64};
                    symbols::Vector=[],
                    normalize=true)
    n = length(distribution)
    isnothing(symbols) ? symbols = collect(1:n) : 0
    normalize ? distribution /= sum(distribution) : 0

    T = eltype(symbols)
    return DiscreteMemorylessSource{T}(
        symbols,
        Dict(symbols[i] => distribution[i] for i in 1:n))
end

entropy(X::DiscreteMemorylessSource) = entropy(dms.distribution)