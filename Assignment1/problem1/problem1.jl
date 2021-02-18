using Random
using Plots
pyplot()
num = [10^4, 5*10^4, 10^5, 5*10^5, 10^6, 2*10^6]     #number of samples
avg = []
for i in num
    sum = 0
    Random.seed!(11)
    for _ in 1:i
        sum = sum + rand(-5000:5000)
    end
    push!(avg, sum/i)
end

#println(avg)                   # Any[-0.8598, -0.9137, -13.36558, -2.135244, -0.967774, 0.1103305]
plot(num, avg, legend=false)
xlabel!("number of integers")
ylabel!("Mean")
scatter!(num,avg)