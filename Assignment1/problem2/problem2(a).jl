# Without Replacement

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
println(n_count/num_iter)       # probabilites corresponding to n jacks	