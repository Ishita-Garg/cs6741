# Calculating experimental probability

using Random

# array of valid characters for password
characters = [ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z', '0','1','2','3','4','5','6','7','8','9','~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`']

Random.seed!(10)
correct_pswd = randstring(characters,8)   # password with which other passwords are compared
Number_of_trials = 10^6
random_pswd = []                        
Random.seed!(10)
for _ in 1:Number_of_trials
    push!(random_pswd,randstring(characters,8))     # randomly generated passwords
end
stored_count = 0                    # count of passwords that will be stored in database
for i in 1:Number_of_trials
    count = 0                       # count of characters matched in passwords
    for j in 1:8                    # loop for matching at each position
        if correct_pswd[j] == random_pswd[i][j]
            count += 1
        end
        if count == 2
            break
        end
    end
    if count == 2
        global stored_count += 1
    end
end

exp_probability = stored_count/Number_of_trials    # probability of a password getting stored in the database
println(exp_probability)

# Calculating theoretical probability


n = 8
p = 1/78
q = 77/78
p_atleast_2 = 0 
for x in 2:8
p_atleast_2 += binomial(n,x)*(p^x)*(q^(n-x))
end
println(p_atleast_2)

# Comparing theoretical and experimental probabilities
difference = p_atleast_2 - exp_probability
println(difference)

#o/p: 0.004325
#0.004371819702646031
#4.6819702646030796e-5