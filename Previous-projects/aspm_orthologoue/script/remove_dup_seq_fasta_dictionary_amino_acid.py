'''
   This script generates dictionary whose keys are accession numbers and values are the bitscore from the multisequences fasta file resulted from the blastp run.
   The dictionary is later used to remove duplicated sequences from the multisequences fasta file (main module filter_dup_seq_fasta_amino_acid.py).
'''

from collections import OrderedDict
from collections import defaultdict

def get_bit_score(strin):
   if ']' in strin:
      gcf_list = strin.split(':')
      bit_score = int(gcf_list[2])
   return bit_score

def read_line_from_file(fasta_file):
   ''' This is the main function to run
   Input: fasta file
   Output:
   '''
   #dict_accesion_score = OrderedDict()
   dict_accesion_score = defaultdict(list)
   dict_accesion_score_unique = dict()
   acc_num_list = []
   list_bitscore = []
   infile = open(fasta_file)
   #outfile = open("fasta.no.duplicates.fasta","w")
   for line in infile:
      if line == "" or line == "\n": 
         continue
      if line[0] == '>':
         acc_line = line.split(' ')
         #if isdigit(ac_line[-1][-1]: 
         for word in acc_line:
            if word[0] == '>':
               key = word[1:]
               if key not in acc_num_list:
                  key_found = 0
                  acc_num_list.append(key)
               else:
                  key_found = 1
            else:
               if ']' in word:
                  if key_found == 1:
                     bscore = get_bit_score(word)
                     list_bitscore.append(bscore)
                     #dict_accesion_score[key] = bscore
                     dict_accesion_score[key].append(bscore)
                  else:
                     bscore = get_bit_score(word)
                     #dict_accesion_score[key] = bscore
                     dict_accesion_score[key].append(bscore)
   #print dict(dict_accesion_score)
   for key in dict_accesion_score.keys():
      dict_accesion_score_unique[key] = max(dict_accesion_score[key])
   return dict_accesion_score_unique
#
   #while len(dict_accesion_score.keys()) > 0:
   #   highest = max(dict_accesion_score, key = dict_accesion_score.get) #Get the key with the highest value
   #   dict_accesion_score_unique[highest] = max(dict_accesion_score[highest])
   #   #print(highest, max(sorting[highest])) #Print the key and it's highest value
   #   del dict_accesion_score[highest]
   #return dict_accesion_score_unique

