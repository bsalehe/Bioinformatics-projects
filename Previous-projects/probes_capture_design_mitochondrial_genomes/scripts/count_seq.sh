#!/bin/bash

n=1
for file in $lf; do echo "number of fasta seq in file $n $file is " && grep "^>" $file | wc -l; n=$(( $n+1 )); if [ "$n" -gt "$nf" ]; then break; fi; done;

