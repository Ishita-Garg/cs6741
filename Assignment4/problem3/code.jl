using Distributions
using QuadGK
μ = 100
σ = 30
answer = 0
for n in 1:50
    D_n = Normal(n*μ, sqrt(n)*σ)
    area = quadgk(x->pdf(D_n, x), (3000, 6000)...)[1]
    if area>=0.95
        answer = n
        print(answer)
        break
    end
end