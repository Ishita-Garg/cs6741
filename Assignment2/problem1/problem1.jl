using DataFrames

df = DataFrame()
df.religion = ["Agnostic", "Atheist", "Buddhiist", "Catholic", "Don't know/ Refused", "Evangelical prot", "Hindu", "Historically Black Prot", "Jehova's Witness", "Jewish"]
df."<\$10k" = [27,12,27,418,15,575,1,228,20,19]
df."\$10-20K" = [34,27,21,617,14,869,9,244,27,19]
df."\$20-30K" = [60,37,30,732,15,1064,7,236,24,25]
df."\$30-40K" = [81,52,34,670,11,982,9,238,24,25]
df."\$40-50K" = [76,35,33,638,10,881,11,197,21,30]
df."\$50-75K" = [137,70,58,1116,35,1486,34,223,30,95]	
print(df)
tidy_df = stack(df, 2:7, :religion)
sorted_tidy_df = sort(tidy_df)
print(rename!(sorted_tidy_df,[:religion,:income,:frequency]))