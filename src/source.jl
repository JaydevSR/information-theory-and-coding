abstract type InformationSource end

struct DiscreteMemorylessSource{T} <: InformationSource where T
    symbols::Vector{T}
    nsymbols::Int
    distribution::Dict{T, Float64}
end

function DiscreteMemorylessSource(
                    distribution::Vector{Float64};
                    symbols::Vector=collect(1:length(distribution)),
                    normalize=true)
    nsymbols = length(distribution)
    isnothing(symbols) ? symbols = collect(1:nsymbols) : 0
    normalize ? distribution /= sum(distribution) : 0

    T = eltype(symbols)
    return DiscreteMemorylessSource{T}(
        symbols,
        nsymbols,
        Dict(symbols[i] => distribution[i] for i in 1:nsymbols))
end

entropy(dms::DiscreteMemorylessSource) = entropy(collect(values(dms.distribution)))
Base.length(source::DiscreteMemorylessSource) = source.nsymbols