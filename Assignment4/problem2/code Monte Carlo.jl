using Random
using Distributions

probability_going_ahead = 0
no_of_samples = 100000
Random.seed!(0)
answer = 0
for p in 0.58:0.0001:0.6
    no_of_experiments_in_favour = 0
    for i in 1:no_of_samples
        if(sum([rand(Bernoulli(p)) == true for _ in 1:50])>=30)
            no_of_experiments_in_favour += 1
        end
    end
    final_probability = no_of_experiments_in_favour/no_of_samples
    if final_probability>=0.5
        probability_going_ahead = final_probability
        answer = p
        println("p = ", answer)
        println("probability_going_ahead = ", probability_going_ahead)
        break
    end
end