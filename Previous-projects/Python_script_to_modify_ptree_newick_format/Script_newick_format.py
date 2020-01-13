#!/usr/bin/python
from __future__ import division
import os, sys
sys.argv

def make_word_list(f):
    """ Read 'A_cp.txt' file and build a list of words

    f: file

    returns: list
    """
    t = [] # This is a list to be returned
    # Open and read file
    #fr = open('words.txt')
    #line = fr.readline()
    #line = line.strip() # remove white space
    #word = line.split(' ')
    for line in open(f):
        word = line.strip()
        t.append(word)
        #t = t + [w]
    return t

def read_word_tree1(f):
    '''Read file containing word tree or characters
    f: file

    returns a single string s of characters and words from the file f
    '''
    s = ''
    for line in open(f):
        line = line.strip() # Remove any space/newline
        s = s + line
    return s

def read_string_tolist(s):
    ''' Read string s from function read_word_tree1() and split into list by ','

    returns a lists
    '''
    return s.split(',')

def read_list_to_sublist(list_t):
    '''Read list from read_string_tolist() and create sublist
    list_t: a list
    returns a sub list list_t
    '''
    sub_list = []
    for item in list_t:
        item = item.split(':')# To create sublist, split each element using ':'
        sub_list.append(item) # Append the item into newly created sub_list
    return sub_list
	
def join_element_of_list(sublist_t):
    '''Read list elements from the sublist_t and join two elements
    to create a new list
    sublist_t: a list
    returns a list
    '''
    a_new_list = []
    if len(sublist_t) == 1: # If the sublist_t contains one element then concatenate with a_new_list which is empty
	    a_new_list = a_new_list + sublist_t
    else: # Otherwise of the sublist_t contains two elements then join them using ':' and create a new list with one element
	    joinchar = ':'
	    joined_items = joinchar.join(sublist_t)
	    a_new_list.append(joined_items)
    return a_new_list

def joined_elements_from_list(new_list_copy):
	''' Take a list of text and float strings and join each float element
        with the previous text/float element, e.g ['eeeee','12.3455'] which will
        be ['eeeee:12.3455']
	new_list_copy: A list of text and float strings 
	return: list
	'''
	new_list = list()
	my_new_list = list()
	for list_item in new_list_copy:
		flag_int = False
		for char in list_item:
			if char.isdigit(): # Check if the first character of the element in the list_item is integer
				flag_int = True
				break # Get out of the 2nd loop if the flag is true
		if flag_int: # if it is true the character is integer
			new_list.append(list_item)# Append the item to the list of the temporary list
			#call_function_to_join_list_items(new_list)
			temp_new_list = join_element_of_list(new_list)# assign to another temporary list the joined alpha and float string from the new_list
			my_new_list = my_new_list + temp_new_list # add on the existing elements of the new list
			new_list = [] # Initialise back the new_list to empty so another list_item to be concatenated (joined) if meet conditions.
			temp_new_list = [] # Initialise back the temp_new_list to empty to take on new joined elements
			continue
		new_list.append(list_item)
	return my_new_list

def joined_elements_of_list2(prev_list):
    ''' Take a list of text and float strings and join with the next float element	
    of the previous joined list, i.e from joined_elements_from_list()
    prev_list: A list of text and float strings from joined_elements_from_list()
    return: list
    '''
    new_list = list()
    my_new_list = list()
    for list_item in prev_list:
        for char in list_item:
            if not char.isdigit(): # Check if the first character in the list_item is of chr type or is not of integer type
                flag_int = False # if True then assign flag_int to be False and break the loop
                break
            else: # If char is digit
                flag_int = True
                new_list.append(list_item)# Append the string with float to new list
                break # then get out of the inner loop to the next line of the outer loop
        if flag_int == True: # If True then
            new_list = [my_new_list[-1]] + new_list # Append the new_list with the last element of my_new_list
	    #call a function_join_list_items(new_list) to join
            temp_new_list = join_element_of_list(new_list)
            my_new_list = my_new_list[0:-1] + temp_new_list # add the elements of temp_new_list with the existing elements of my_new_list excluding its last element
            new_list = [] # Initialise back the new_list to empty so another list_item to be concatenated (joined) if meet conditions.
            temp_new_list = [] # Initialise back the temp_new_list to empty to take on new joined elements
            continue
        my_new_list.append(list_item)# Append the list_item with other elements in the my_new_list if fails to meet any of the conditions above
    return my_new_list

def word_match_replacement(words_list_file, charwords_to_replace_file):
    ''' Match word from the word list generated from the file 'A_cp.txt'.
    The function is intended to replace once the matched word in the
    file 'B_FOCtree.txt'
    return: new_list 
    '''
    word_list = make_word_list(words_list_file) # Read each word in a line to a list
    new_list = list() # A new list which contains found and replaced words from the file A_cp.txt
    s = read_word_tree1(charwords_to_replace_file) # Read all words or characters into a single big string
    t = read_string_tolist(s) # Split the string s above into list based on ',' character
    t1 = read_list_to_sublist(t) # Split the list t above into sublist based on ':' character
    temp_list = [] # A temporary empty list to store the found words which is used to replace the string and 
                   # to be joined if matched with the word from the word_list above

    for item in t1: # Iterate over the items of the main list which are sublist
        for element in item: # Iterate the element of inner list (sublist), i.e individual strings
            required_bracket = '' # Handling brackets of some of the element originated from the file B_FOCtree.txt
				  # Initialise bracket to empty char each time when iterating over new string element
            for letter in element: # Iterate over each character of the single string element of the sublist
                if letter == '(': # Check whether the char is bracket
                    required_bracket = required_bracket + letter # If it is bracket append to the existing required_bracket
                    continue  # Go to the next letter/char of the element in the loop
                if letter == '_': # Check if the char in the element is '_'
                    break # If True break (get out of) this inner loop and go to the next line which follows
            subsublist = element.split('_')# Split the element into list based on the '_'
            for subitem in subsublist: # Iterate over each item of the list created on the fly from this element
                if subitem in word_list: # Check whether the item is in the list of words from A_cp.txt, i.e. find
                    if not subitem in temp_list: # To avoid replacing item (word) many times or is replaced once,
						 # use temporary list to store the item once. Check whether the item
						 # is not in the temporary list
                        temp_list.append(subitem) # If it is not then add it on the temporary list otherwise (if False)
						  # it will loop another item
                        element = required_bracket + subitem # And concatenate with bracket and replace the element with item
            new_list.append(element) # Append the element to the new list after replacement or if not replaced (i.e. no match)
				     # and the go back to the most outer loop to iterate over another sublist item
    return new_list

def search_and_replace_characters(text_file_with_list_words, text_file_with_characterwords_to_replace, output_textfile):
    import sys
    ''' search words concatinated with '_' in file 'text_file_with_characterwords_to_replace' and replace with single word from file 'text_file_with_list_words'
    text_file_with_list_words: text file contains list of words
    text_file_with_characterwords_to_replace: text file with characters and words to be replaced with each single word from file text_file_with_list_words
    output_textfile: name of the output text file
    files should be in the same directory/folder and single quoted when passing the parameters during script running
    example is :- python ./word_tree1_edited_latest1.py 'A_cp.txt','B_FOCtree.txt','B_FOCtree_new1.txt'
    The output file 'B_FOCtree_new1.txt' will be in the same directory/folder
    return: text file with replaced words
    '''
    list_1 = word_match_replacement(text_file_with_list_words, text_file_with_characterwords_to_replace)# Return list with word replaced once
    join_element_list1 = joined_elements_from_list(list_1)# Join elements with float
    join_element_from_list2 = joined_elements_of_list2(join_element_list1)# Join te previous joined list with floats with another float
    new_single_string_with_all_replaced_words = ','.join(join_element_from_list2) # Concaatenate the entire list into a single string
    ## Write to a file
    text_file = open(output_textfile,'w')
    text_file.write(new_single_string_with_all_replaced_words)
    text_file.close()
    
if __name__ == '__main__':
    infile1 = str(sys.argv[1])
    infile2 = str(sys.argv[2])
    outfile = str(sys.argv[3])
    search_and_replace_characters(infile1, infile2, outfile)
    print 'finished run, please open the output file from your folder'
    
