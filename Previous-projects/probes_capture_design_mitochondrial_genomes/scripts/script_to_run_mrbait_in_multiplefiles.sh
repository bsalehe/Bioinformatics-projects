#!/bin/bash

n=1
nf=$(ls -l | grep ".fasta" | wc -l) ##number of fasta files in the current directory
lf=$(ls | grep ".fasta") ## list all fasta files in the current directory
for file in $lf
do
mrbait -A $file -T 4 -b 60 -s tile=24 -o "out_baits_$n
n=$(( $n+1 ))
if [ "$n" -gt "$nf" ]
then
break
fi
done


