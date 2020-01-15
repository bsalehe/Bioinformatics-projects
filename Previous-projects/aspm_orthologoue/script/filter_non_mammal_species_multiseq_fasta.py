#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 13 21:37:12 2019
Filter non-mammals species from the mulitiseq fasta file

@author: bajuna
"""

def filter_dup(fasta_file):
   infile = open(fasta_file)
   outfile = open("/home/bajuna/Desktop/JoBaker/proteins/combined_initial_gene_aspm_seq5_initial_gene_aspm_seq6.fasta_no_nonmammals0.fasta","w")
   infile_names = open("/home/bajuna/bioinf_projects/Jo/reciprocal_BLAST/assembly_summary_mamal_names_v2.txt")
   org_names_list = []
   for line_names in infile_names:
      line_names=line_names.strip()
      org_names_list.append(line_names)

   for line in infile:
      #count = 0
      if line[0] == '>':
         flag = 0
         acc_line = line.split('|')
         for sentence in acc_line:
            if sentence[0] == '>':
               sentence = sentence.split(' ')
               for i in range(len(sentence)-1):
                  org_name = sentence[i][1:] + ' ' + sentence[i+1][0:-1] #Mammalian names with two names
                  if org_name in org_names_list:
                     outfile.write(line)
                     flag = 1
                     break
      elif line[0] != '>' and flag == 1:
         outfile.write(line.strip().upper() + "\n")
   #print org_names_list
   infile.close()
   infile_names.close()
   outfile.close()

if __name__=='__main__':
   filter_dup('/home/bajuna/combined_initial_gene_aspm_seq5_initial_gene_aspm_seq6.fasta')
   #filter_dup('/home/bajuna/Desktop/JoBaker/proteins/aspm/aspm_prot_blast_new_no.duplicates.fasta_with_abnormal.fasta')
   
