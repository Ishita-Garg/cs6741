using QuadGK
using Distributions

function percentile_(D, n)
	return quadgk(x->pdf(D,x), (-Inf, n)...)[1]
end

function OneSidedTail_N(x)
    for i in -50:0.01:50
        if(percentile_(Normal(0,1),i)>= (100-x)/100)
            return i
        end
    end
end

function OneSidedTail_T(x)
    for i in -50:0.01:50
        if(percentile_(TDist(10),i)>= (100-x)/100)
            return i
        end
    end
end

function OST_Normal(x)
	println("Percentile of standard normal distribution calculated at OneSidedTail(", x,") is ", percentile_(Normal(0,1), OneSidedTail_N(x))*100)
end

function OST_TDist(x)
	println("Percentile of Student's T distribution with v = 10 calculated at OneSidedTail(", x,") is ", percentile_(TDist(10), OneSidedTail_T(x))*100)
end

OST_Normal(95)          # 5.050258347410373
OST_TDist(95)           # 5.020114749695301

N = []
T = []
for x in 1:99
    push!(N, OneSidedTail_N(x))
    push!(T, OneSidedTail_T(x))
end
plot( N,label="Normal distribution")
plot!( T, label="Student's T distribution")
scatter!([95], [OneSidedTail_N(95)],label="")
scatter!([95], [OneSidedTail_T(95)],label="")
xlabel!("x")
ylabel!("OneSidedTail(x)")