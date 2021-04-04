using Statistics
using Plots
pyplot()

data = [3 for _ in 1:760]
for _ in 1:479
    push!(data,1)
end
for _ in 1:640
    push!(data,5)
end
for _ in 1:600
    push!(data,7)
end
for _ in 1:500
    push!(data,9)
end
for _ in 1:350
    push!(data,11)
end
for _ in 1:200
    push!(data,13)
end
for _ in 1:100
    push!(data,15)
end
for _ in 1:70
    push!(data,17)
end
for _ in 1:20
    push!(data,19)
end
for _ in 1:15
    push!(data,21)
end
for _ in 1:15
    push!(data,23)
end
for _ in 1:10
    push!(data,25)
end

# println(mean(data))			# 6.67438148443735
# println(median(data))			# 7.0
# println(skewness(data))		#  0.9395301449670395

histogram(data,label="", title = "Synthetic Dataset")
plot!([mean(data) for _ in 0:0.01:1], 0:600, line=3, label="Mean", color="green")
plot!([median(data) for _ in 0:0.01:1], 0:600, line=3, label="Median", color="red")
plot!([mode(data) for _ in 0:0.01:1], 0:760, line=3, label="Mode", color="orange")
xlabel!("Data values")
ylabel!("Frequency")	
