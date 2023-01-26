"""
    is_kraft_compatible(L::Vector{Integer}; base=2)

Check if the given vector of codeword lengths satisfies the Kraft inequality.
"""
is_kraft_compatible(L::Vector{Integer}; base=2) = (sum(base .^ -L) <= 1)

struct HuffmanEndcoder{T}
    alphabet::Vector{T}
    alphabet_size::Integer
end

function HuffmanEndcoder(alphabet::Vector{T}) where T
    alphabet_size = length(alphabet)
    return HuffmanEndcoder{T}(alphabet, alphabet_size)
end

HuffmanEndcoder() = HuffmanEndcoder([true, false], 2)

function encode(source, encoder::HuffmanEndcoder)
    coding = Dict(source.alphabet[i] => "" for i in 1:source.alphabet_size)

    # Sort the alphabet by probability
    sorted_alphabet = sort(source.alphabet, by=(i -> source.distribution[i]))
    sorted_distribution = [source.distribution[i] for i in sorted_alphabet]

    while length(sorted_distribution) > 1
        # TODO
    end
end
