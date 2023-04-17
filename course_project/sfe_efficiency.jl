include("../src/itc.jl")
using Plots

# dist = [0.15, 0.85]
dist = [0.55, 0.25, 0.20]
# dist = [0.45, 0.25, 0.15, 0.10, 0.05]

huffman = ShannonFanoEliasEncoder()

source = DiscreteMemorylessSource(dist)

code = encode(source, huffman)

η = coding_efficiency(source, code)

# η v.s. n

nmax = 5
η_nrange = zeros(Float64, nmax)

for n in 1:nmax
    dist_rep = repeat_distribution(dist, n)
    η_nrange[n] = coding_efficiency(dist_rep, encode(dist_rep, huffman))
end

println(η_nrange)

plot(1:nmax, η_nrange,
    xlabel = "n",
    ylabel = "η = H_dist / L_avg",
    title = "Efficieny of SFE encoding with repetation \n distribution: $dist")
