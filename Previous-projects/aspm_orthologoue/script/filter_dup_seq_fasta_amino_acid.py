import remove_dup_seq_fasta_dictionary_amino_acid as rd
def filter_dup(fasta_file):
   infile = open(fasta_file)
   outfile = open("/home/bajuna/Desktop/JoBaker/proteins/aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2_no.duplicates.fasta","w")
   dict_accesion_score_unique = dict()
   dict_accesion_score_unique = rd.read_line_from_file(fasta_file)
   tmp_acc_num_list = []
   for line in infile:
      #count = 0
      if line[0] == '>':
         flag = 0
         #for word in line.split(' '):
         acc_line = line.split(' ')
            #if word[0] == '>':
         for word in  acc_line:
            if ']' in word:
            #if word.startswith('[gbkey=mRNA]') or word.startswith('[gbkey=CDS]'):
               bscore = rd.get_bit_score(word)
         if acc_line[0][1:] in dict_accesion_score_unique.keys():# and bscore in dict_accesion_score_unique.values():
            if acc_line[0][1:] not in tmp_acc_num_list:
               tmp_acc_num_list.append(acc_line[0][1:])
               outfile.write(line)
               flag = 1            
            else:
               continue
      elif line[0] != '>' and flag == 1:
         outfile.write(line.strip().upper() + "\n")
   
   infile.close()
   outfile.close()

if __name__=='__main__':
   filter_dup('/home/bajuna/Desktop/JoBaker/proteins/aspm_prot_blast_new_no.duplicates.fasta_with_abnormal_no_nonmammals_all_mammals_blast_hits2.fasta')
   #filter_dup('/home/bajuna/Desktop/JoBaker/proteins/aspm_prot_blast_new.fasta')
   #filter_dup('/home/bajuna/Desktop/JoBaker/aspm_nucleotide_blast_hits1.fasta')

