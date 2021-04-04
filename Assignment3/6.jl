using Dates
using DataFrames
using CSV
using Statistics
using StatsBase

# function for getting week from dates
function get_week(d)
	w = []
	for i in d
	 if(Dates.year(i) == 2020)
	 push!(w, Dates.week(i) - Dates.week(d[1]) + 1)
	 else
	 push!(w, Dates.week(i)+53 - Dates.week(d[1]) + 1)
	 end
	end
	return w
end

# function to get rank of element in array
findpos(arr) = [indexin(arr[i], sort(arr))[1] for i in 1:length(arr)]

# loading data
df = CSV.read("D:\\IITM\\sem2\\DS\\A3\\q6_data.csv", DataFrame)
select!(df, :Date, :State, :Confirmed)
#print(df)

# unstacking states as columns
udf = unstack(df, :State, :Confirmed)
for col in eachcol(udf)
    replace!(col,missing => 0)
end
#print(udf)

# creating "week" column from date
select!(udf, :Date => (x -> get_week(x)) => :week, :)
select!(udf, Not(:Date))
select!(udf, Not(:India))
#print(udf)

# calculating "new" cases from confirmed cases
for j in 2:size(udf)[2]
    for i in size(udf)[1]:-1:2
        udf[!,j][i] -= udf[!, j][i-1]
    end
end
#print(udf)

# grouping on "week"
gdf = groupby(udf, :week)

# aggregating weekly data for all states
cdf = combine(gdf, [names(udf)[i] => sum for i in 2:38])
print(cdf)

# Computing Statistics
	
covariance = zeros((size(cdf)[2]-1,size(cdf)[2]-1))
n_cols = length(names(cdf))

for i in 2: n_cols
    for j in 2:n_cols
    covariance[i-1, j-1] = cov(cdf[:,names(cdf)[i]], cdf[:,names(cdf)[j]])
    end
end

pearson_cor = zeros((size(cdf)[2]-1,size(cdf)[2]-1))
n_cols = length(names(cdf))
for i in 2: n_cols
    for j in 2:n_cols
    pearson_cor[i-1, j-1] = cor(cdf[:,names(cdf)[i]], cdf[:,names(cdf)[j]])
    end
end

spearman_cor = zeros((size(cdf)[2]-1,size(cdf)[2]-1))
n_cols = length(names(cdf))
for i in 2: n_cols
    for j in 2:n_cols		 
        i_rank = findpos(cdf[:,names(cdf)[i]])
        j_rank = findpos(cdf[:,names(cdf)[j]])
        spearman_cor[i-1, j-1] = cor(i_rank, j_rank)
    end
end

#Plotting heatmaps
heatmap(1:n_cols-1, 1:n_cols-1, covariance, c=cgrad(:haline, rev=true), xlabel="State 1", ylabel="State 2", title="Covariance")
heatmap(1:n_cols-1, 1:n_cols-1, pearson_cor, c=cgrad(:haline, rev = true), xlabel="State 1", ylabel="State 2", title="Pearson’s coefficient of correlation")
heatmap(1:n_cols-1, 1:n_cols-1, spearman_cor, c=cgrad(:haline, rev = true), xlabel="State 1", ylabel="State 2", title="Spearman’s coefficient of correlation")
