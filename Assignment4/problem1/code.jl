using Random
no_of_samples = 100000
Random.seed!(5)
no_of_experiments_in_favour = 0
for i in 1:no_of_samples
    if(sum([rand(0:1) for _ in 1:50])>=30)
        global no_of_experiments_in_favour += 1
    end
end
final_probability = no_of_experiments_in_favour/no_of_samples
print(final_probability)