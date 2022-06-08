#!/bin/bash

for f in *.xlsx
do
 echo "import pandas as pd" > rm_dup.py
 echo "data = pd.read_excel('$f')" >> rm_dup.py
 echo "data.sort_values('species', inplace=True)" >> rm_dup.py
 echo "data.drop_duplicates(subset = 'species', keep = 'last', inplace = True)" >> rm_dup.py
 echo "df=pd.DataFrame(data)" >> rm_dup.py
 echo "df.to_excel('no_dup_$f')" >> rm_dup.py
python rm_dup.py
done
#

