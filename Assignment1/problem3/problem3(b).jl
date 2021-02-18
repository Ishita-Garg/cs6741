## With Replacement

# Calculating theoretical probability using binomial distribution

n = 5
p = 1/13
x = [i for i in 0:5]

theoretical_prob = []
for val in x
    push!(theoretical_prob, binomial(n,val)*(p^val)*((1-p)^(n-val)))
end
println(theoretical_prob)
# Any[0.670176922268936, 0.2792403842787234, 0.046540064046453895, 0.0038783386705378243, 0.0001615974446057427, 2.6932907434290447e-6]

# Calculating experimental probability
using Random

num_cards = 1:52
# deck of 52 cards with 1,14,27,40 corresponding to aces of 4 diff types,
# 1-13 -> cards of one house (say hearts), 14-26 -> cards of second house (say spades) and so on.
cards = [i for i in num_cards] 	

jacks = [11,24,37,50]
num_iter = 10^6                 # number of trials
n_count = [0,0,0,0,0,0]         # array corresponding to number of jacks (0-5)

Random.seed!(1)
for _ in 1:num_iter
    jack_count = 0		
    card_drawn = [rand(cards) for _ in 1:5]     # drawing 5 cards
    for i in 1:5
        if any(card_drawn[i] .== jacks)         # counting number of jacks in each trial
            jack_count += 1
        end
    end
        n_count[jack_count+1] += 1              # counts of n-jacks
end
exp_prob = n_count/num_iter
println(exp_prob)       # probabilites corresponding to n jacks	
# Float64 [0.670835, 0.278986, 0.046221, 0.003809, 0.000148, 1.0e-6]

# Comparing experimental and theoretical probabilites

diff  = theoretical_prob - exp_prob
println(diff)
# Float64 [-0.000658078, 0.000254384, 0.000319064, 6.93387e-5, 1.35974e-5, 1.69329e-6]