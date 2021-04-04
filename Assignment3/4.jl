using Random
using Statistics
using Distributions
using Plots
pyplot()

Random.seed!(2)
samples = []
range = []
for i in 1:1000
    push!(samples,rand(Uniform(0,1),30))
    push!(range, maximum(samples[i]) - minimum(samples[i]))
end
histogram(range,label="",bins=30)
plot!([mean(range) for _ in 0:0.01:1], 0:74, line=3, label="Mean", color="green")
plot!([median(range) for _ in 0:0.01:1], 0:98, line=2.5, label="Median", color="red")
plot!([mode(range) for _ in 0:0.01:1], 0:98, line=3, label="Mode", color="yellow")
xlabel!("Range of 10000 samples")
ylabel!("Frequency")
