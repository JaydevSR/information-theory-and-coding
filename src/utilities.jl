function entropy(distribution; normalize=false)
    normalize ? distribution /= sum(distribution) : 0
    return -sum(distribution .* log2.(distribution))
end
