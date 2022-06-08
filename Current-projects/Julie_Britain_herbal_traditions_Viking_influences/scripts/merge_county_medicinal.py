import pandas as pd
data = pd.read_excel('medicinal_plants_per_county.xlsx')
data1 = pd.read_excel('summary_results_null_populations_Aberdeenshire.xlsx')
pd.DataFrame(data)
df = pd.DataFrame(data)
df1 = pd.DataFrame(data1)
merged_no_dup = pd.merge(data, data1[['species']], how='inner', on='species')
df_merged=pd.DataFrame(merged_no_dup)
df_merged.to_csv('medicinals_county_no_dup_Peeblesshire.xlsx.csv')
