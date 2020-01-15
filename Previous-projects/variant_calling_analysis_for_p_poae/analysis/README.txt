SNIPPY pipeline v4.4.0 in the command line (CL) mode was used for calling and annotating variants for each given strain. SNIPPY has been designed specifically for calling variants in haploid organisms.

The output files from the SNIPPY are in the folders which have been named using the strains' names, i.e 'aphid', 'biofilm' and 'wildtype'. Each of these strain was mapped against its corresponding assembled genome. The output variants obtained were unique for each strain. All three strains were additionally mapped against the ref wildtype (23146_wildtype_ppoae). The variants associated with these mapping are in the folders 'aphid_strain_against_wildtype' and 'biofilm_strain_against_wildtype'. Each folder contains the following file:-
- 'snps.csv' - A csv file containing detected annotated variants of each strain. This can be opened in the spreadsheet program such as Excel.
- 'snps.filt.vcf' - A raw filtered vcf file containing individual variants.
- 'snps.html' - Detailed annotated variants of the strains in html format which can be opened using standard browsers
- 'snps_annotated.vcf' - Raw annotated vcf file of the variants
- 'snps_summary.txt' - Short summary stats of each strain's related variants detected by SNIPPY.

Description of the columns in the TAB/CSV/HTML/VCF formats:
Name 	Description
CHROM 	The sequence the variant was found in eg. the name after the > in the FASTA reference
POS 	Position in the sequence, counting from 1
TYPE 	The variant type: snp mnp ins del complex (see below)
REF 	The nucleotide(s) in the reference
ALT 	The alternate nucleotide(s) supported by the reads
EVIDENCE 	Frequency counts for REF and ALT
FTYPE 	Class of feature affected: CDS tRNA rRNA ...
STRAND 	Strand the feature was on: + - .
NT_POS 	Nucleotide position of the variant withinthe feature / Length in nt
AA_POS 	Residue position / Length in aa (only if FTYPE is CDS)
LOCUS_TAG 	The /locus_tag of the feature (if it existed)
GENE 	The /gene tag of the feature (if it existed)
PRODUCT 	The /product tag of the feature (if it existed)
EFFECT 	The snpEff annotated consequence of this variant (ANN tag in .vcf)

Variant Types
Type 	Name 					Example
snp 	Single Nucleotide Polymorphism 		A => T
mnp 	Multiple Nuclotide Polymorphism 	GC => AT
ins 	Insertion 				ATT => AGTT
del 	Deletion 				ACGG => ACG
complex Combination of snp/mnp 			ATTC => GTTA

Impact prediction for annotated variants are categorised as HIGH, MODERATE, LOW, and MODIFIER (Note: Impact categories must be used with care, they were created only to help and simplify the filtering process. Obviously, there is no way to predict whether a HIGH impact or a LOW impact variant is the one producing a phenotype of interest):

- HIGH - The variant is assumed to have high (disruptive) impact in the protein, probably causing protein truncation, loss of function or triggering nonsense mediated decay. Example:- stop_gained, frameshift_variant.
- MODERATE - A non-disruptive variant that might change protein effectiveness. Example:- missense_variant, inframe_deletion.
- LOW - Assumed to be mostly harmless or unlikely to change protein behavior. Example:-	synonymous_variant.
- MODIFIER - Usually non-coding variants or variants affecting non-coding genes, where predictions are difficult or there is no evidence of impact. Example:- exon_variant, downstream_gene_variant

In addition, there is a folder named 'core_sites_wildtype_aphid_biofilm' which contains files with core snps. These are variant sites which are common in all three strains. It contains the following files:
- 'core.tab' - Tab-separated column list of core SN sites with alleles.
- 'core.vcf' - Multi-sample VCF file with genotype GT tags for all discovered alleles.

