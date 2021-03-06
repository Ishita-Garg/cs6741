using HTTP
using JSON
using DataFrames
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

# function for caculating moving average
function moving_average(array)
	return [sum( array[i:(i+6)])/7 for i in 1:(length(array)-(6))]
end

function plots_(data1,data2,label1,label2,title_)
	plot(data1,label=label1,title = title_)
	plot!(data2,label = label2,linewidth=2)	
end

function get_year_month(var)
    return [(var[i][1:7]) for i in 1:length(var)]
end

df = create_df()       

# changing datatype from string to int
df.dailyconfirmed = [parse(Int, x) for x in df.dailyconfirmed]
df.dailydeceased = [parse(Int, x) for x in df.dailydeceased]
df.dailyrecovered = [parse(Int, x) for x in df.dailyrecovered]

# selecting required columns
select!(df, :dateymd , :dailyconfirmed, :dailydeceased,  :dailyrecovered)

# caculating moving average of 7 preceeding days for all three classes
mov_avg_cnfrmd = moving_average(df.dailyconfirmed)
mov_avg_deceased = moving_average(df.dailydeceased)
mov_avg_recovd = moving_average(df.dailyrecovered)

# Plots
plots_(df.dailyconfirmed,mov_avg_cnfrmd,"original values","smoothened values", "Plot for confirmed cases")
plots_(df.dailydeceased,mov_avg_deceased,"original values","smoothened values", "Plot for deceased cases")
plots_(df.dailyrecovered,mov_avg_recovd,"original values","smoothened values", "Plot for recovered cases")