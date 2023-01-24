function entropy(distribution; normalize=false)
    normalize || distribution /= sum(distribution)
    return -sum(distribution .* log2.(distribution))
end

entropy(X::DiscreteMemorylessSource) = X.entropy
