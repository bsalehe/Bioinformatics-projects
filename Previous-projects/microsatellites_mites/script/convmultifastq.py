from Bio import SeqIO # the SeqIO module is the standard Sequence Input/Output interface for >= BioPython 1.43
from glob import glob # The glob module finds all the pathnames matching a specified pattern according to the rules used by the Unix shell

file_list = glob('./*.ab1') # Get directory path containing .ab1 files

for file_path in file_list:
    count = SeqIO.convert(file_path, "fastq", file_path + "_" + ".ab1", "abi")
    print("Converted %i records" % count)
