using HTTP
using JSON
using DataFrames
using Dates

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

print(aggregated_data)