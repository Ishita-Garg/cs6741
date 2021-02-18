## Without Replacement

# Calculating theoretical probability using hypergeometric distribution

n = 5
m = 4
N = 52
x = [i for i in 0:5]
theoretical_prob = []
for val in x
    push!(theoretical_prob, binomial((N - m),(n - val))*binomial(m,val)/binomial(N,n))
end
println(theoretical_prob)     
# Any[0.6588419983377967, 0.2994736356080894, 0.03992981808107859, 0.0017360790470034167, 1.846892603195124e-5, 0.0]

# Calculating experimental probability

using Random

num_cards = 1:52
# deck of 52 cards with 1,14,27,40 corresponding to aces of 4 diff types,
# 1-13 -> cards of one house (say hearts), 14-26 -> cards of second house (say spades) and so on.
cards = [i for i in num_cards] 	

jacks = [11,24,37,50]
num_iter = 10^6             # number of trials
n_count = [0,0,0,0,0,0]     # array corresponding to number of jacks (0-5)

Random.seed!(1)
for _ in 1:num_iter
    cards_drawn = []
    deck = copy(cards)      # using a copy of deck of cards for each trial
    jack_count = 0	
    for i in 1:5                # drawing 5 cards without replacement
        draw = rand(deck)
        push!(cards_drawn,draw)
        deleteat!(deck, findfirst(x-> x == draw, deck))
    end
    
    for i in 1:5                          # counting number of jacks in each trial
        if any(cards_drawn[i] .== jacks)
            jack_count += 1
        end
    end
        n_count[jack_count+1] += 1      # counts of n-jacks
end
exp_prob = n_count/num_iter
println(exp_prob)       # probabilites corresponding to n jacks	
# Float64 [0.659486, 0.299086, 0.039705, 0.001709, 1.4e-5, 0.0]

# Comparing experimental and theoretical probabilites

diff  = theoretical_prob - exp_prob
println(diff)
# Float64 [-0.000644002, 0.000387636, 0.000224818, 2.7079e-5, 4.46893e-6, 0.0]