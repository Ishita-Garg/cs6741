using Plots
using Random
using Statistics
using StatsBase
using Distributions

Random.seed!(3)
function smallest_sample_size(D)
    for sample_size in 1:200
        samples = [sum((rand(D, sample_size).-mean(D))./std(D)) for _ in 1:num_samples]./sqrt(sample_size)
        samples = convert(Array{Float64,1},samples)
        mean_ = mean(samples)
        var_ = var(samples)
        skew = skewness(samples)
        kurt = kurtosis(samples)
        if abs(mean_) < 0.1 && abs(var_-1) < 0.1 && abs(skew) < 0.1 && abs(kurt) < 0.1
            println("For distribution ", D, ", the smallest sample size is ", sample_size)
            return samples 
        end
    end
end

mean_, var_, skew, kurt = 0, 0 ,0 ,0
num_samples = 10^5
final_samples = []
distributions = [Uniform(0,1), Binomial(500, 0.01), Binomial(10, 0.5), Chisq(3)]
for D in distributions
    push!(final_samples, smallest_sample_size(D))
end

x = -4:0.01:4
histogram(final_samples[1],normalize = true, label="Uniform(0,1)")
plot!(x, pdf.(Normal(0,1), x), label = "Normal(0,1)", line = 4)

histogram(final_samples[2],normalize = true, label="Binomial(0.01)")
plot!(x, pdf.(Normal(0,1), x), label = "Normal(0,1)", line = 4)

histogram(final_samples[3],normalize = true, label="Binomial(0.5)")
plot!(x, pdf.(Normal(0,1), x), label = "Normal(0,1)", line = 4)

histogram(final_samples[4],normalize = true, label="Chi-Square(3)")
plot!(x, pdf.(Normal(0,1), x), label = "Normal(0,1)", line = 4)