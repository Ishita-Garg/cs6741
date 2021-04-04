using Distributions
using QuadGK

function KLD(P, Q)
	return quadgk(x-> pdf(P,x)*log2(pdf(P,x) /(pdf(Q,x))), (-10,10)...)[1]
end

begin
	kld = []
	for i in 1:5
		push!(kld,KLD(TDist(i),Normal(0,1)))
	end
    print(kld)
end