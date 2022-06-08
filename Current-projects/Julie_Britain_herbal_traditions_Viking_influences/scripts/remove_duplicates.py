#
#
import pandas as pd
data = pd.read_excel("Aberdeenshire.xlsx")
data.sort_values("species", inplace=True)
data.drop_duplicates(subset = "species", keep = False, inplace = True)
df=pd.DataFrame(data)
df.to_excel('Aberdeenshire_no_dup.xlsx')

