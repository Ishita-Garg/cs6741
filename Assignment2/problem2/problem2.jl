using DataFrames
using Random
using Dates

# defining required functions

# function for creating untidy DataFrame
function creating_df()
    cols = [string(i, base = 10, pad = 2) for i in 1:30]
	data = [[if (i==3 || i==4) && (j==29 || j==30) missing else (if i%2 == 1 rand(22.4:.1:32.6) else rand(9.8:.1:18.6) end) end for i in 1:24] for j in 1:30]
	el = []
	for _ in 1:12
		push!(el,"tmax")
		push!(el,"tmax")
	end
	
	df = DataFrame()
	df.id = ["MX17004" for _ in 1:24]
	df.year = [2010 for _ in 1:24]
	df.month = [i÷2 for i in 2:25]
	insertcols!(df, 4, (:element => el), makeunique=false)	
	
	for i in 1:30
		name = cols[i]
		insertcols!(df, 4+i, (cols[i] => data[i]), makeunique=false)
	end
	
	_31 = []
	for i in 1:14
		temp = [missing,rand(22.4:.1:32.6),rand(9.8:.1:18.6),missing]
		push!(_31,temp[i%4 + 1])
	end
	for i in 15:24
		temp = [rand(22.4:.1:32.6),missing,missing,rand(9.8:.1:18.6)]
		push!(_31,temp[i%4 + 1])
	end
	insertcols!(df,35,(:"31" => _31), makeunique=false)
	
	return df
end

# function for getting 'id' from the tuple 'id_year_month_days'
function get_id(var)
    return [var[i][1][1] for i in 1:length(var)]
end

# function for getting 'date' from the tuple 'id_year_month_days'
function get_date(var)
    return [Date(var[i][1][2], var[i][1][3], parse(Int64, var[i][2][:])) for i in 1:length(var)]
end


df = creating_df()             # untidy df
gdf = groupby(df,:month)       # grouping on months

# combining id, year and month columns
df_id_year_month = combine(gdf, [:id, :year, :month] => ((i, y, m)->(i[1],y[1],m[1]))=>"id_year_month",:element,:"01",:"02",:"03",:"04",:"05",:"06",:"07",:"08",:"09",:"10",:"11",:"12",:"13",:"14",:"15",:"16",:"17",:"18",:"19",:"20",:"21",:"22",:"23",:"24",:"25",:"26",:"27",:"28",:"29",:"30" , :"31")

# stacking the date columns (01-31)
temp_df1 = stack(df_id_year_month,4:34,:id_year_month)
rename!(temp_df1,:variable => :days)
rename!(temp_df1,:value => :temp)

# combining id-year-month and date columns
temp_df2 = combine(groupby(temp_df1,[:id_year_month,:days]), [:id_year_month, :days] => ((p, s)->(p[1],s[1]))=>"id_year_month_days",:temp)
select!(temp_df2,Not([:id_year_month,:days]))

# dropping missing values
temp_df2 = dropmissing(temp_df2)
insertcols!(temp_df2,2,:element =>[["tmin","tmax"][i%2+1] for i in 1:nrow(temp_df2)])

# unstacking temperature rows
dat = unstack(temp_df2, :element, :temp)

# getting tidy DataFrame by spliting 'id_year_month_days' variable to 'id' and 'date'
tidy_df = select(dat,:id_year_month_days=>(x->get_id(x))=>"id", :id_year_month_days=>(x->get_date(x))=>"date",:tmax,:tmin)
	
print(df)
print(tidy_df)