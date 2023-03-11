"""
    is_kraft_compatible(L::Vector{Integer}; base=2)

Check if the given vector of codeword lengths satisfies the Kraft inequality.
"""
is_kraft_compatible(L::Vector{Integer}; base=2) = (sum(base .^ -L) <= 1)

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
        pass_distribution = push!(distribution[1:nsymbols-2], mintwo_merged)
        subcode = encode(pass_distribution, encoder)

        code[1:end-2] = subcode[1:end-1]
        code[end-1] = subcode[end]*"0"
        code[end] = subcode[end]*"1"
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
    trunc_lengths = ceil.(log.(inv.(distribution))) .+ 1

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
