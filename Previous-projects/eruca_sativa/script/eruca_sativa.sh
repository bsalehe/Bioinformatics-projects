#!/bin/bash

############################################################################
# Script to simplify the use of many options in using EMBLmyGFF3
############################################################################

#PATH to the FASTA file used to produce the annotation
GENOME="/home/bajuna/bioinf_projects/LBell_Eruca_sativa/data/Eruca_sativa_novogene_genome.fa"

#PATH to the ANNOTATION in gff3 FORMAT
ANNOTATION="/home/bajuna/bioinf_projects/LBell_Eruca_sativa/data/Annotations/final_set_gff3.gff3.gz"

#PROJECT name registered on EMBL
PROJECT="PRJEB34051"

#Locus tag registered on EMBL
LOCUS_TAG="BJ0819"

# species name
SPECIES="Eruca vesicaria subsp. sativa"

# Taxonomy
TAXONOMY="PLN"

#The working groups/consortia that produced the record. No default value
#REFERENCE_GROUP="Bajuna

#Translation table
TABLE="1"

#Molecule type of the sample.
MOLECULE="genomic DNA"

myCommand="EMBLmyGFF3 -i $LOCUS_TAG -p $PROJECT -m \"$MOLECULE\" -r $TABLE -t linear -s \"$SPECIES\" -x $TAXONOMY -o /home/bajuna/bioinf_projects/LBell_Eruca_sativa/data/EMBLmyGFF3-maker-example.embl $ANNOTATION $GENOME $@"
echo -e "Running the following command:\n$myCommand"

#execute the command
eval $myCommand

##### running webin-cli.jar for submitting/uploading annotation data in ENA ##################
java -jar webin-cli.jar -context sequence -manifest /home/bajuna/bioinf_projects/LBell_Eruca_sativa/data/Annotations/manifest.tab -userName Webin-52335 -password '******6767**' -outputDir /home/bajuna/bioinf_projects/LBell_Eruca_sativa/analysis/webcli_out_new -inputDir /home/bajuna/bioinf_projects/LBell_Eruca_sativa/data/Annotations/ -validate -submit

