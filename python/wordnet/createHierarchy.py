import shelve
import numpy as np
from nltk.corpus import wordnet as wn 


#http://wordnet.princeton.edu/man/wngloss.7WN.html
#http://www.nltk.org/howto/wordnet.html


#create vectors and save in shelf
def createVectors(wordlist):
	db = shelve.open('wordnet.db',protocol=2)

	for word in wordlist:
		#create if word not in db
		if word not in db:
			data = wn.synsets(word,pos=wn.NOUN)
			associated_words = []
			for f in data:
				associated_words += list(set([w for s in f.closure(lambda s:s.hyponyms()) for w in s.lemma_names]))
			print word,":",",".join(associated_words)
			db[w] = associated_words

	db.close()
	print "Done"

def printVectors(wordlist):
	for word in wordlist:
		data = wn.synsets(word,pos=wn.NOUN)
		associated_words = []
		for f in data:
			associated_words += list(set([w for s in f.closure(lambda s:s.hyponyms()) for w in s.lemma_names]))
		#print word,":",",".join(associated_words)
		print ",".join(associated_words) + ","
		#print "\n"
	print "Done"

if __name__ == '__main__':
	wordlist = ['movies', 'languages', 'computer', 'fruit', 'animal', 'people', 'vehicle', 'actions', 'food']
	printVectors(wordlist)
