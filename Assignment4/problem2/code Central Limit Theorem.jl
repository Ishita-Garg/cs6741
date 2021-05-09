using Distributions
using QuadGK
n = 50
answer = 0
for p in 0.5:0.0001:0.6
    D_n = Normal(n*p, sqrt(n*p*(1-p)))
    area = quadgk(x->pdf(D_n, x), (29.5, 50)...)[1]
    if area>=0.5
        global answer = p
        break
    end
end
print(answer)