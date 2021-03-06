using HTTP
using JSON
using DataFrames

# defining required functions

# function for creating DataFrame of the JSON data
function create_df()
    resp = HTTP.get("https://api.covid19india.org/data.json")
    str = String(resp.body)
    jobj = JSON.Parser.parse(str)
    df = reduce(vcat, DataFrame.(jobj["cases_time_series"]))
    return df
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

# getting year and month from dates
select!(df, :dateymd => (x->get_year_month(x))=> :date_y_m, :dailyconfirmed, :dailydeceased,  :dailyrecovered)

# grouping and caculating aggregate
gdf = DataFrames.groupby(df, :date_y_m)
aggregated_data = combine(gdf, :dailyconfirmed => sum, :dailydeceased => sum, :dailyrecovered => sum)

print(aggregated_data)