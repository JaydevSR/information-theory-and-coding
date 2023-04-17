function entropy(distribution::Vector{Float64}; normalize=false)
    normalize ? distribution /= sum(distribution) : false
    return -sum(distribution .* log2.(distribution))
end

function repeat_distribution(dist::Vector{Float64}, n::Int)
    len = length(dist)
    dist_n = copy(dist)
    for i in 1:n-1
        dist_n = repeat(dist_n, len)
        for p in eachindex(dist)
            @views dist_n[(p-1)*(len)^i + 1:p*(len)^i] *= dist[p]
        end
    end
    return dist_n
end
