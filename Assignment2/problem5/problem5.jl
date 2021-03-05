using HTTP
using JSON
using DataFrames
using Dates
using Plots
pyplot()

# defining required functions

# function for creating DataFrame of the JSON data
function create_df()
    resp = HTTP.get("https://api.covid19india.org/data.json")
    str = String(resp.body)
    jobj = JSON.Parser.parse(str)
    df = reduce(vcat, DataFrame.(jobj["cases_time_series"]))
    return df
end

function get_year(var)
    return [Dates.year(var[i]) for i in 1:length(var)]
end
function get_month(var)
    return [Dates.month(var[i]) for i in 1:length(var)]
end

# fucntion for getting date from corresponding year and month
function get_date(y,m)
	return [Date(Dates.Year(y[i]),Dates.Month(m[i])) for i in 1:length(y)]
end

# function for caculating moving average
function moving_average(array,n)
	return [sum(@view array[i:(i+n-1)])/n for i in 1:(length(array)-(n-1))]
end


function confirmed_cases_plot(aggregated_data,mov_avg_cnfrmd)
    scatter(aggregated_data.date,aggregated_data.totalconfirmed_sum, label="")
	scatter!(aggregated_data.date[7:end],mov_avg_cnfrmd, label="")
	plot!(aggregated_data.date,aggregated_data.totalconfirmed_sum, label="actual values", title = "Confirmed cases plot")
	plot!(aggregated_data.date[7:end],mov_avg_cnfrmd, label="moving average")
	xlabel!("Dates")
end

function deceased_cases_plot(aggregated_data,mov_avg_deceased)
    scatter(aggregated_data.date,aggregated_data.totaldeceased_sum, label="")
	scatter!(aggregated_data.date[7:end],mov_avg_deceased, label="")
	plot!(aggregated_data.date,aggregated_data.totaldeceased_sum, label="actual values", title = "Deceased cases plot")
	plot!(aggregated_data.date[7:end],mov_avg_deceased, label="moving average")
	xlabel!("Dates")
end

function recovered_cases_plot(aggregated_data,mov_avg_recovd)
    scatter(aggregated_data.date,aggregated_data.totalrecovered_sum, label="")
	scatter!(aggregated_data.date[7:end],mov_avg_recovd, label="")
	plot!(aggregated_data.date,aggregated_data.totalrecovered_sum, label="actual values", title = "Recovered cases plot")
	plot!(aggregated_data.date[7:end],mov_avg_recovd, label="moving average")
	xlabel!("Dates")
end

df = create_df()       

# changing datatype from string to int/date as suitable
select!(df, Not([:date]))
df.dateymd = Date.(df.dateymd, "yyyy-mm-dd")
df.dailyconfirmed = [parse(Int, x) for x in df.dailyconfirmed]
df.dailydeceased = [parse(Int, x) for x in df.dailydeceased]
df.dailyrecovered = [parse(Int, x) for x in df.dailyrecovered]
df.totalconfirmed = [parse(Int, x) for x in df.totalconfirmed]
df.totaldeceased = [parse(Int, x) for x in df.totaldeceased]
df.totalrecovered = [parse(Int, x) for x in df.totalrecovered]
select!(df, :dateymd , :dailyconfirmed, :dailydeceased,  :dailyrecovered, :totalconfirmed, :totaldeceased , :totalrecovered)

# getting year and month from dates
df.year = get_year(df.dateymd)
df.month = get_month(df.dateymd)

# grouping and caculating aggregate
gdf = DataFrames.groupby(df, [:month,:year])
aggregated_data = combine(gdf, :totalconfirmed => sum, :totaldeceased => sum, :totalrecovered => sum)

# combining month and year to a date
select!(aggregated_data, [:year,:month] => ((y,m) -> get_date(y,m)) => :date, :totalconfirmed_sum, :totaldeceased_sum, :totalrecovered_sum)

# caculating moving average of 7 preceeding days for all three classes
mov_avg_cnfrmd = moving_average(aggregated_data.totalconfirmed_sum,7)
mov_avg_deceased = moving_average(aggregated_data.totaldeceased_sum,7)
mov_avg_recovd = moving_average(aggregated_data.totalrecovered_sum,7)

# Plots
confirmed_cases_plot(aggregated_data,mov_avg_cnfrmd)
deceased_cases_plot(aggregated_data,mov_avg_deceased)
recovered_cases_plot(aggregated_data,mov_avg_recovd)