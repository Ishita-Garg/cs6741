using Random
using Distributions
using Plots

p = [x for x in 0:0.05:1]			# range of probability of gain (1-p accordign to ques)
atleast10_prob = []                 # required probability for each p
iterations = 10^5

for x in p                          # calc probability for diff value of probability of gain
    favourable_count = 0            # trials with outcome of more than Rs 10
    Random.seed!(1)
    for _ in 1:iterations
        initial_amt = 10
        outcome = rand(Bernoulli(x),20)     # array of outcome of 20 days
        amt = initial_amt
        
        for i in 1:20
            if outcome[i] == true           # gain
                amt += 1
            else
                amt -= 1                    # loss
            end
        end
        
        if amt >= 10                        # atleast Rs 10
            favourable_count += 1
        end
    end
    push!(atleast10_prob, favourable_count/iterations)
end

println(atleast10_prob)

function prob_plot(p,atleast10_prob)
    pyplot()
    plot(p,atleast10_prob,legend=false)
    scatter!(p,atleast10_prob,legend=false)
    xlabel!("Probability of gain (1-p)")
    ylabel!("Probability at least Rs 10 are left")
end

prob_plot(p,atleast10_prob)