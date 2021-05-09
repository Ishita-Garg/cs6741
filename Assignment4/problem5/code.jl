using Statistics
using StatsBase
using Distributions
probability=0.0
val = 0
given_Variance=5
required_Variance=given_Variance*100/99
reqvar = 0
for i in 1:0.000001:10
    probability=1-cdf(Chisq(99), 99*required_Variance/i)
    if 0.1-probability<0.000001 && 0.1-probability>0 
        reqvar = i
        print(reqvar)
        break
    end
end