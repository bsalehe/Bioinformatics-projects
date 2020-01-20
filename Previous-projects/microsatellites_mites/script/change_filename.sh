#!/bin/bash
## Add underscoree at the end of the file
IFS='
'

for i in {1..23}; do 
	
	mv -i "sample ($i).fastq" "sample ($i).fastq/ ($i)/_$i";

done
