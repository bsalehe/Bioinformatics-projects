import pandas as pd
import os
from glob import glob

list_of_100_plants = []

for xlsxfiles in sorted(glob('*.xlsx')):
    data = pd.read_excel(xlsxfiles)
    df = pd.DataFrame(data)
    plants = df['species'].values.tolist()
    list_of_100_plants.append(plants)

plant_look_up_list = []
dict_count_list = dict()
#count = 0
for item_plant_list in list_of_100_plants:
   count = 0
   for plant in item_plant_list:
     if plant not in plant_look_up_list and count == 0:
       count = count + 1
       dict_count_list[plant] = count
       plant_look_up_list.append(plant)
     elif count >= 1 and plant not in plant_look_up_list:
       #if count >= 1 and plant not in plant_look_up_list:
         count = 0
	 plant_look_up_list.append(plant)
         count = count + 1
	 dict_count_list[plant] = count
     else:
       dict_count_list[plant] = dict_count_list[plant] + count
#
df_0to100times = pd.DataFrame.from_dict(dict_count_list, orient='index', columns=['0_to_100_times'])
df_0to100times.to_excel("summary_results_null_populations.xlsx")
