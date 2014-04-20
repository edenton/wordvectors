import shelve
import numpy as np
DBLOC = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews.db'
QUESTION_LOC = '../../word2vec/questions-words.txt'

def testAnalogicalShelve():
	#Test on analogical reasoning from shelve database
	db = shelve.open(DBLOC)
	err_lines = []	
	f_question = open(QUESTION_LOC,'r')
	for l in f_question:
		line = l.strip()
		if line.startswith(":"):
			print "Now testing: ",line
		else:
			words = line.split(' ')
			vA = -1
			
			
	db.close()

if __name__ == "__main__":
	testAnalogicalShelve()
