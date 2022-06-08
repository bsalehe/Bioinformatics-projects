#!/usr/bin/bash

for dest in *output2_*/
do
  cp -v summary_100_plants.py "$dest"
  cd "$dest"
  python summary_100_plants.py
  cd ../
done
