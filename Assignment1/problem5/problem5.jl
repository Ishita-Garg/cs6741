using Random

# array of valid characters for password
characters = [ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z', '0','1','2','3','4','5','6','7','8','9','~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`']

Random.seed!(10)
correct_pswd = randstring(characters,8)   # password with which other passwords are compared
Number_of_trials = 10^6
random_pswd = []                        
Random.seed!(10)
for _ in 1:Number_of_trials
    push!(random_pswd,randstring(characters,8))  # randomly generated passwords
end

stored_count = zeros(9)        # count of passwords that will be stored in database each corresponding to number of characters match

for i in 1:Number_of_trials
    count = 0                       # count of characters matched in passwords
    for j in 1:8                    # loop for matching at each position
        if correct_pswd[j] == random_pswd[i][j]
            count += 1
        end
    end
global stored_count[count+1] += 1
end

exp_probability = stored_count/Number_of_trials    # probability of a password getting stored in the database 

cumulative_prob = []     # probability that atleast x characters match
for x in 1:8
	push!(cumulative_prob, sum(exp_probability[x:8]))
end
println(cumulative_prob)   

# Any[0.999999, 0.09803, 0.004324, 0.000107, 4.0e-6, 0.0, 0.0, 0.0]

index = -1       # as indexing starts with 0
for i in cumulative_prob
      global index += 1
      if i < 0.001          
        break
    end
end
println(index)     # output: 3  i.e. atleast 3 characters match