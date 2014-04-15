#!/bin/python
from scipy.sparse import *
import shelve
import numpy as np

def main():
	
	DBLOC     = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews.db'
	OUTPUTDIR = '/misc/vlgscratch3/FergusGroup/rahul/vectors/custVectors/all_words'
	WORDLOC   = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsWords.txt'
	
	#all three million words
	f = open(WORDLOC,'r')
	all_words = set([line.strip() for line in f.readlines()])
	f.close()

	num_words = 3000000
	X = np.zeros((num_words,300))
	db_vec = shelve.open(DBLOC)
	idx = 0
	print "Reading vectors"
	for w in all_words: 
		if idx % 10000 == 0:
			print "---- " + str(idx) + " ----"
		X[idx,:]=np.array(db_vec[w].todense())
		idx = idx + 1
	db_vec.close()
	
	print "Saving matrix in "
	print OUTPUTDIR+'.wnvec'
#	np.savetxt(OUTPUTDIR+'.wnvec',X,'%.8f',delimiter=',')
	print "Done. "

if __name__ == '__main__':
	main()	
