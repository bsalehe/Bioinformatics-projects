# -*- coding: utf-8 -*-
"""
Created on Thu Mar 19 09:47:57 2020

@author: Bsalehe
"""

import pandas as pd
data = pd.read_excel('medicinal_plants_per_county.xlsx')
data1 = pd.read_excel('summary_results_null_populations_Aberdeenshire.xlsx')
#pd.DataFrame(data)
df = pd.DataFrame(data)
df1 = pd.DataFrame(data1)
merged_no_dup = pd.merge(data, data1[['species']], how='inner', on='species')
df_merged=pd.DataFrame(merged_no_dup)
df_merged.to_excel('Name_of_plant.xlsx')

#df1 = pd.DataFrame([['a', 'b'], ['c', 'd']],index=['row 1', 'row 2'],columns=['col 1', 'col 2'])