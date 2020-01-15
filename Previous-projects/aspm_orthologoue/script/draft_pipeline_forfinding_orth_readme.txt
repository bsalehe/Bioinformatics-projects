##Download genomes refseq (nt) from NCBI/Ensembl/DDBJ. [NCBI]
bash script available
## use entrez direct (edirect) to search for gene / protein (aspm) and retrieve its sequences from ncbi databases
#
##for gene (nucleotide) with cds
esearch -db nucleotide -query "ASPM[Symbol]" | efetch -format fasta > aspm_nuc_output.fasta
#
###Filter the nucleotide multifasta file using the python scripts - remove none aspm sequences (filter_abnormal_spindle_from_esearch_seq.py), clones(manually), some partial sequences (manually)
#
####Filter non-mammal species (python script)
#
##Install blast and blast databases (for nucleotides)
makeblastdb -dbtype `nucl' -in ~/bioinf_projects/Jo/reciprocal_BLAST/db_nt/all_genomes.fna -out ~/bioinf_projects/Jo/reciprocal_BLAST/db_nt/nt_blastdb &
#
blastn -query /home/bajuna/Desktop/JoBaker/aspm_filterered_non_mammal_species.fasta -db ~/bioinf_projects/Jo/reciprocal_BLAST/db_nt/nt_blastdb -outfmt 5 -out /home/bajuna/Desktop/JoBaker/aspm_nucleotide_blast.xml -evalue 1e-10 -word_size 11
#
## Extract the fasta sequences from the blast hits ('.xml' file). Use the blasta2fasta.xsl script from P.Linderbaum available here: https://raw.githubusercontent.com/lindenb/xslt-sandbox/master/stylesheets/bio/ncbi/blast2fasta.xsl
#
####Install xsltproc to run the downloaded stylesheet above
sudo apt-get install xsltproc
#
####Run the xsl file as follows, e.g.:
xsltproc -\-novalid blast2fasta.xsl aspm_nucleotide_blast.xml > aspm_nucleotide_blast_hits1.fasta
#
##Filter out all sequences which are not genes of your interest (input: aspm_nucleotide_blast_hits1.fasta).
Python script (filter_aspm_nucleotide_seq.py/filter_aspm_seq.py respectively)
#
##Filter out all duplicated sequences 
Python script (filter_dup_seq_fasta_nucleotide.py)
#
##Run second blast for RBH+
###For nucleotide sequences (blastn)
blastn -query aspm_nucleotide_blast_hits1_fasta.no.duplicates.fasta -db ~/Jo/db/nt_blastdb -outfmt 5 -out aspm_nucleotide_blast_hits2.xml -evalue 1e-10 -soft_masking true -num_alignments 1 &
#
##Again run the xsl file as follows, e.g.:
xsltproc -\-novalid blast2fasta.xsl aspm_nucleotide_blast.xml > aspm_nucleotide_blast_hits2.fasta (supposed to be orthologous cds set)
#
################################For protein sequences #####################################
##Extract associated protein sequences using esearch
esearch -db gene -query "ASPM[Symbol]" | elink -target protein | efetch -format fasta > proteins/initial_gene_aspm_seq_new_0.fasta
#
###Perform initial filtering and blastp run
#
#### Initial filtering 
#####Filter the protein multifasta sequence file using the python script - remove none aspm sequences(script), related sequence clones(manually), some partial sequences (manually), sequences with accession numbers that start with >J, >E, >A, etc (non >XP_ or >NP_).
#
#####Filter non-mammal species (python script: filter_non_mammal_species_seq_fasta_prot.py)
#
#### Initial blastp run
blastp -query /home/bajuna/Desktop/JoBaker/proteins/aspm_filterered_non_mammal_species_prot2.fasta -db ~/bioinf_projects/Jo/reciprocal_BLAST/db_prot/prot_blastb -outfmt 5 -out /home/bajuna/Desktop/JoBaker/proteins/aspm_prot_blast_new.xml -evalue 1e-10 -num_alignments 600
#
####Run the xsl file to obtain fasta sequences from blastp hits run 1
xsltproc -\-novalid ../blast2fasta.xsl aspm_prot_blast_new.xml > aspm_prot_blast_new.fasta &
### Perform second filtering and blastp
#### Second filtering
a. remove duplicates (filter_dup_seq_fasta_amino_acid.py, remove_dup_seq_fasta_dictionary_amino_acid.py)
b. remove proteins that are not aspm related from blastp run 1 (python filter_aspm_seq_v2_a.py)
c. remove proteins that are non_mammals (python filter_non_mammal_species_seq_fasta_v2_a1.py, python filter_non_mammal_species_seq_fasta_v2_a1_1.py)
d. combine the two fasta files in c using cat (cat aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals0.fasta aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals.fasta > aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals.fasta)
#
#### Second blastp using 'aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals.fasta' file
#
blastp -query /home/bajuna/Desktop/JoBaker/proteins/aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals.fasta -db ~/bioinf_projects/Jo/reciprocal_BLAST//db_prot/prot_blastb -outfmt 5 -out /home/bajuna/Desktop/JoBaker/proteins/aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2.xml -num_alignments 1 -seg yes -soft_masking true -use_sw_tback
#
####Run the xsl file to obtain fasta sequences from blastp hits run 2
xsltproc -\-novalid ../blast2fasta.xsl aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2.xml > aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2.fasta
#
### Remove duplicates using python scripts (remove_dup_seq_fasta_dictionary_amino_acid.py and filter_dup_seq_fasta_amino_acid.py)
#
### Break sequences from single to multilines using fasta_formatter tool from BBMap ensuite tools.
#
### Manually edit sequences with less aa based on the original fasta file used for second blasting and find mismatching sequences between the two files, i.e. those not presence from the second blastp hits fasta file but are present in the original fasta files.
## Count unique number of sequences of aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2_no.duplicates_multi_line_seq_updated.fasta
and 'aspm_nucleotide_blast_hits2.fasta' using grep.
grep "^>" aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2_no.duplicates_multi_line_seq_updated.fasta | wc -l
grep "^>" ../aspm_nucleotide_blast_hits2_fasta.no.duplicates.fasta | wc -l
##Compare the cds from 'aspm_nucleotide_blast_hits2.fasta' with the associated aa fasta file from run 2 blast hits (i.e. 'aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2_no.duplicates_multi_line_seq_updated.fasta').
### Add those cds with no corresponding proteins from ncbi into separate file (missing_cds_nucleotide_aspm.fasta)/same file (aspm_nucleotide_blast_hits2.fasta).


