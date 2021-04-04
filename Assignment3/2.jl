using Distributions
using Plots
pyplot()

function convolve(current_dist)     # convolving current_dist and Uniform distribution
    con_pdf = []
    for x in -5:0.01:10
        push!(con_pdf, sum(current_dist[x-k]*pdf(Uniform(0,1),k) for k in -5:0.01:10))
    end    
    con_pdf /= 101      # normalizing area under the curve
    return con_pdf
end
    
function KLD(P, Q)      # KL diveregnce function for discrete distributions
    d = 0
    for i in 1:length(P)
        if(P[i] != 0)
            d+=P[i]*log2(P[i]/Q[i])
        end
    end
    return d
end
    
n = [i for i in 2:10]

# creating discrete Uniform distribution
current_dist = Dict()   
for i in -5:0.01:10
    current_dist[i] = pdf(Uniform(0,1),i)
end

kld = []        # array for storing KL diveregnce value for n = 2 to 10

for _ in n
    con_pdf = []                      # array for storing convolved distribution valuess
    con_pdf = convolve(current_dist)

    # creating dictionary from the array
    j = 1
    for i in -5:0.01:10
        current_dist[i] = con_pdf[j]
        j+=1
    end
    
    # calculating mean and standard deviation for fitting a normal distribution
    E = 0
    E_square = 0
    for i in -5:0.01:10
        E += i*current_dist[i]
        E_square += (i^2)*current_dist[i]
    end
    E = E/100
    E_square = E_square/100
    var_ = E_square - E^2
    std_ = sqrt(var_)
   
    N = pdf.(Normal(E, std_), -5:0.01:10)

    # calculating and storing KL diveregnce values
    push!(kld, KLD(con_pdf, N))
end

plot(n, kld, legend = false)
scatter!(n, kld,color = "blue")
ylabel!("KL Diveregnce")
xlabel!("Number of convolved pdfs (n)")