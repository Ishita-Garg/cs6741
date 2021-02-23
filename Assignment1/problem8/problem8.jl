using Random
using Distributions
using Plots

p = [x for x in 0:0.05:1]			# range of probability of gain (1-p accordign to ques)
conditional_probabilities = []                 # required probability for each p
iterations = 10^5

for x in p
    bankrupt_count = 0
    atleast10_n_0_bankrupt = 0
    Random.seed!(1)

    for _ in 1:iterations            
        initial_amt = 10
        outcome = rand(Bernoulli(x),20)
        amt = initial_amt
        flag = 0
        
        for i in 1:20
            if outcome[i] == true
                amt += 1
            else
                amt -= 1
            end
            if amt == 0
                bankrupt_count += 1
                flag = 1
                break
            end
        end        
        if amt >= 10 && flag == 0
            atleast10_n_0_bankrupt += 1
        end
    end
    bankrupt_prob = bankrupt_count/iterations
    atleast10_n_0_bankrupt_prob = atleast10_n_0_bankrupt/(iterations-bankrupt_count)
    conditional_prob = atleast10_n_0_bankrupt_prob/(1-bankrupt_prob)
    push!(conditional_probabilities, conditional_prob)
end

println(conditional_probabilities)

function prob_plot(p,conditional_probabilities)
    pyplot()
    plot(p,conditional_probabilities,legend=false)
    scatter!(p,conditional_probabilities,legend=false)
    xlabel!("Probability of gain (1-p)")
    ylabel!("Conditional probability")
end

prob_plot(p,conditional_probabilities)