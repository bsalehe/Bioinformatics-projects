esearch -db assembly -query "Pseudomonas poae[ORGN]" | efetch -format docsum | xtract -pattern DocumentSummary -element FtpPath_RefSeq |awk -F"/" '{print "curl -o "$NF"_genomic.fna.gz " $0"/"$NF"_genomic.fna.gz"}'

#########################################################################################
## Download aspm protein sequences
esearch -db gene -query "ASPM" | elink -target protein | efilter -query "REVIEWED[FILTER]" | efetch -format fasta > ~/Desktop/ASPM.fasta
#
##Counting number of sequences
cat ~/Desktop/Aspm.fasta | grep -v "^>" | wc -l
#4125
##Download genomic sequences 
esearch -db assembly -query "Homo sapiens[ORGN]" | efetch -format docsum | xtract -pattern DocumentSummary -element FtpPath_RefSeq |awk -F"/" '{print "curl -o "$NF"_genomic.faa.gz " $0"/"$NF"_genomic.faa.gz"}'


