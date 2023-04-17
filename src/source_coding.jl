"""
    is_kraft_compatible(L::Vector{Integer}; base=2)

Check if the given vector of codeword lengths satisfies the Kraft inequality.
"""
is_kraft_compatible(L::Vector{Integer}; base=2) = (sum(base .^ -L) <= 1)

function average_length(distribution::Vector{Float64}, codes::Vector{String})
    @assert length(distribution) == length(codes)
    sum(distribution .* map(length, codes))
end

function average_length(source::DiscreteMemorylessSource{T}, codes::Dict{T, String}) where {T}
    average_length([source.distribution[s] for s in source.symbols], [codes[s] for s in source.symbols])
end

function coding_efficiency(distribution::Vector{Float64}, codes::Vector{String})
    entropy(distribution; normalize = true) / average_length(distribution, codes)
end

function coding_efficiency(source::DiscreteMemorylessSource{T}, codes::Dict{T, String}) where {T}
    entropy(source) / average_length(
        [source.distribution[s] for s in source.symbols],
        [codes[s] for s in source.symbols])
end

struct HuffmanEncoder end

function encode(source::DiscreteMemorylessSource, encoder::HuffmanEncoder)
    sorted_symbols = sort(source.symbols, by=(x -> source.distribution[x]), rev=true)
    codes = source.distribution |> values |> collect |> x -> encode(x, encoder)
    return Dict(zip(sorted_symbols, codes))
end

function encode(distribution::Vector{Float64}, encoder::HuffmanEncoder)
    if length(distribution) == 1
        return ["0"]
    elseif length(distribution) == 2
        return ["0", "1"]
    else
        nsymbols = length(distribution)
        code = ones(String, nsymbols)
        sort!(distribution, rev=true)

        mintwo_merged = distribution[end-1] + distribution[end]
        pos_merged = findfirst(x -> x < mintwo_merged, distribution)
        pass_distribution = push!(distribution[1:nsymbols-2], mintwo_merged)
        subcode = encode(pass_distribution, encoder)

        code[1:pos_merged-1] = subcode[1:pos_merged-1]
        code[pos_merged:end-2] = subcode[pos_merged+1:end]
        code[end-1] = subcode[pos_merged]*"0"
        code[end] = subcode[pos_merged]*"1"
        return code
    end
end

struct ShannonFanoEliasEncoder end

function encode(source::DiscreteMemorylessSource, encoder::ShannonFanoEliasEncoder)
    sorted_symbols = sort(source.symbols, by=(x -> source.distribution[x]), rev=true)
    codes = source.distribution |> values |> collect |> x -> encode(x, encoder)
    return Dict(zip(sorted_symbols, codes))
end

function encode(distribution::Vector{Float64}, encoder::ShannonFanoEliasEncoder)
    nsymbols = length(distribution)
    sort!(distribution, rev=true)
    cdf = cumsum(distribution)
    modified_cdf = (distribution/2) .+ [0; view(cdf, 1:nsymbols-1)]
    trunc_lengths = ceil.(log2.(inv.(distribution))) .+ 1

    codes = [binary_decimal(p, l) for (p, l) in zip(modified_cdf, trunc_lengths)] 
end

function binary_decimal(d, l, head="")
    if l == 0
        return head
    else
        d *= 2
        d >= 1 ? binary_decimal(d - 1, l - 1, head*"1") : binary_decimal(d, l - 1, head*"0")
    end
end
