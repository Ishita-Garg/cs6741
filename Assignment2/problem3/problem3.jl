using DataFrames
using Dates

# data for DataFrame
a = ["2pac" for _ in 1:7]
append!(a, ["2Ge+her" for _ in 1:3])
append!(a, ["3 Doors Down" for _ in 1:5])
t = [4:22 for _ in 1:7]
append!(t, [3:15 for _ in 1:3])
append!(t, [3:53 for _ in 1:5])
tr = ["Baby Don't Cry" for _ in 1:7]
append!(tr, ["The Hardest Part Of..." for _ in 1:3])
append!(tr, ["Kryptonite" for _ in 1:5])
w = [i for i in 1:7]
append!(w, [i for i in 1:3])
append!(w, [i for i in 1:5])

# creating DataFrame
df = DataFrame( year = [2000 for _ in 1: 15], artist = a, time = t, track = tr, 
		date = [Date(2000,02,26), Date(2000,03,04), Date(2000,03,11), Date(2000,03,18), Date(2000,03,25), Date(2000,04,01), Date(2000,04,08), Date(2000,09,02), Date(2000,09,09), Date(2000,09,16), Date(2000,04,08), Date(2000,04,15), Date(2000,04,22), Date(2000,04,29), Date(2000,05,06)],
		week = w, rank =  [87,82,72,77,87,94,99,91,87,92,81,70,68,67,66] )

# printing untidy data
print(df)

# tidy data table 1
insertcols!(df, 1, :id => 1:15, makeunique=true)
tidy_df_1 = unique(df, :artist)
select!(tidy_df_1, :artist, :track, :time)
insertcols!(tidy_df_1, 1, :id => 1:3, makeunique=true)

# tidy data table 2
left_df = copy(tidy_df_1; copycols=true)
tidy_df_2 = innerjoin(left_df, df, on = :artist, makeunique=true)
select!(tidy_df_2, [:id, :date, :rank])

# printing tidy data
print(tidy_df_1)
print(tidy_df_2)