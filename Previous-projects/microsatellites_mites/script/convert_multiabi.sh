#!/bin/bash

echo 'from Bio import SeqIO' > conv_multiabi.py
sudo chmod 755 conv_multiabi.py
for file in *.ab1
do
  echo 'count = SeqIO.convert($file, "abi", "$file.fastq", "fastq")' >> conv_multiabi.py
  echo 'print("Converted %i records" % count)' >> conv_multiabi.py
  python conv_multiabi.py
done
