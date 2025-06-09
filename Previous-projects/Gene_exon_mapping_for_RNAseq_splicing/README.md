# Exon/Contig Analysis Protocol

These protocols are for examining exon IDs and translating DNA/RNA sequences from transcriptome assembly, with focus on functional annotation, protein translation, and domain analysis. The steps below guide you through both the analysis of known exons (e.g., from `counts.txt`) or  original contigs from transcriptome assembly. It can be improved with all advances in tools at the moment. I created this protocol
6 years back as the part of bioinformatics for genomic support for Dr. Sam Boateng's PhD students at the University of Reading, UK.

---

## Protocol 1: ExonID/Transcript Analysis using Ensembl and Related Tools

1. **Open `counts.txt`**  
   Identify and copy the exonID you wish to investigate.

2. **Query Ensembl**  
   - Go to [Ensembl](http://www.ensembl.org/)
   - Paste the exonID into the search bar (choose “All species”)
   - Click “Go” and select the first result (transcript or gene detail)
   - Review genomic location and details

3. **Explore Genomic Region and Variants**  
   - For more tracks: Click **Region in Detail**
   - To view genetic variations: Click **Variant table** on the left menu (see dbSNP variants, etc.)

4. **Get the Sequence**  
   - On the left panel, click **Sequence**
   - Click **Download sequence**
   - Choose file format: FASTA
   - In settings, select **cDNA** or **Coding sequences**
   - Download the sequence file

5. **Translate DNA to Protein**  
   - Visit [Expasy Translate Tool](https://web.expasy.org/translate/)
   - Open the downloaded FASTA file in a text editor (e.g., Notepad++)
   - Copy the sequence and paste it into Expasy
   - Click **Translate** to obtain protein sequence
   - Select the translation frame with the **longest Open Reading Frame (ORF)**

6. **Analyze Protein Sequence**
   - Copy the longest protein sequence
   - Go to [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi) and perform a **protein BLAST** (use default parameters)
     - If the sequence is too short, hits may be insignificant
     - For significant hits, proceed with domain analysis

7. **Protein Domain Analysis**
   - Copy a significant BLAST hit sequence
   - Submit it to [InterPro](https://www.ebi.ac.uk/interpro/search/sequence/) for domain/family annotation
   - Optionally, download all translated ORFs from Expasy and repeat BLAST + InterPro on each

---

## Protocol 2: Contig Translation and Domain Analysis

If working with raw contigs (not annotated exons):

1. **Translate Contigs**
   - Translate each contig into 6 open reading frames (ORFs) to find possible protein-coding regions
   - For longer contigs, you may focus only on all ORFs rather than full 6-frame translation

2. **Domain and Mutation Analysis**
   - Restrict InterPro search to relevant tools/models
   - If reads are strand-specific, you may only need the 3 sense reading frames

3. **Alternative/Additional Tools**
   - [CDD: Conserved Domain Database](https://www.ncbi.nlm.nih.gov/cdd/)
   - [SMART: Simple Modular Architecture Research Tool](http://smart.embl-heidelberg.de/)
   - [PhD-SNP: Predict human deleterious SNPs](https://snps.biofold.org/phd-snp/phd-snp.html) (human only)
   - [PolyPhen2: Predict functional effects of mutations](http://genetics.bwh.harvard.edu/pph2/index.shtml)

---

## Notes

- Always ensure your sequence is in the correct format for each tool.
- For best results, use the longest ORFs and significant BLAST hits for further analysis.
- Refer to the official documentation for each tool for advanced options and troubleshooting.

---
