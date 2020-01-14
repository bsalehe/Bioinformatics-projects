makeblastdb -in ~/bioinf_projects/Jo/reciprocal_BLAST/db_prot/all_genomes_prot.fasta -dbtype prot -out ~/bioinf_projects/Jo/reciprocal_BLAST/db_prot/prot_blastb
#
blastp -query /home/bajuna/Desktop/JoBaker/proteins/aspm_filterered_non_mammal_species_prot.fasta -db ~/bioinf_projects/Jo/reciprocal_BLAST/db_prot/prot_blastb -outfmt 5 -out /home/bajuna/Desktop/JoBaker/proteins/aspm_prot_blast.xml -evalue 1e-10 -num_alignments 600 &
