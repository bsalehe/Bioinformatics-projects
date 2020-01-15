#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 13 21:37:12 2019

@author: bajuna
"""

inputfile = '~/proteins/aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2_no.duplicates.fasta'
length = 70

outfile = open('~/proteins/aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2_no.duplicates_multi_line_seq.fasta', 'w') #open outfile for writing

with open(inputfile, 'r') as f:
     for line in f:
        if line.startswith(">"):
                print >> outfile, line.strip()
        else:
                sequence = line.strip()
                while len(sequence) > 0:
                        print >>outfile, sequence[:length]
                        sequence = sequence[length:]
