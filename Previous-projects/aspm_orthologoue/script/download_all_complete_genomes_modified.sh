#wget ftp://ftp.ncbi.nih.gov/genomes/refseq/assembly_summary_refseq.txt
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_mammalian/assembly_summary.txt

#awk -F '\t' '{if($12=="Complete Genome") print $20}' assembly_summary_refseq.txt > assembly_summary_complete_genomes.txt
awk -F '\t' '{if($12=="Scaffold") print $20}' assembly_summary.txt > assembly_summary_scaffold_genomes.txt
#awk -F '\t' '{if($12=="Chromosome") print $20}' assembly_summary_refseq.txt > assembly_summary_chromosome.txt
awk -F '\t' '{if($12=="Chromosome") print $20}' assembly_summary.txt > assembly_summary_chromosome.txt

mkdir RefSeqVetCompleteGenomes
mkdir RefSeqVetCompleteReports
mkdir RefSeqVetChromosomeGenomes
mkdir RefSeqVetChromosomeReports
mkdir db_nt

for next in $(cat assembly_summary_scaffold_genomes.txt);
do
wget -P RefSeqVetCompleteGenomes "$next"/*genomic.fna.gz;
wget -P RefSeqVetCompleteReports "$next"/*assembly_report.txt;
done

for next in $(cat assembly_summary_chromosome.txt);
do
wget -P RefSeqVetChromosomeGenomes "$next"/*genomic.fna.gz;
wget -P RefSeqVetChromosomeReports "$next"/*assembly_report.txt;
done

gunzip RefSeqVetCompleteGenomes/*.gz
gunzip RefSeqVetChromosomeGenomes/*.gz

python change_fasta_header.py RefSeqCompleteGenomes
python change_fasta_header.py RefSeqChromosomeGenomes

cat RefSeqVetCompleteGenomes/*.fna > db_nt/all_complete_genomes.fna
cat RefSeqVetChromosomeGenomes/*.fna > db_nt/all_chromosomes.fna

cat db_nt/all_complete_genomes.fna db_nt/all_chromosomes.fna > db_nt/all_genomes.fna
