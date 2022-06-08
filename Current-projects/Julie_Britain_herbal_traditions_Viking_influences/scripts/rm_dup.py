import pandas as pd
data = pd.read_excel('Yorkshire.xlsx')
data.sort_values('species', inplace=True)
data.drop_duplicates(subset = 'species', keep = 'last', inplace = True)
df=pd.DataFrame(data)
df.to_excel('no_dup_Yorkshire.xlsx')
