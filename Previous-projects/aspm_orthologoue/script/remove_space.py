## Remove space at the beggining of the line in the fasta file
for line in open('/home/bajuna/bioinf_projects/Jo/script/test_filter_aspm1.fasta'):
    print line.rstrip()
