#!/bin/python
from scipy.sparse import *
import shelve
import numpy as np
from nltk.corpus import wordnet as wn 


#http://wordnet.princeton.edu/man/wngloss.7WN.html
#http://www.nltk.org/howto/wordnet.html

#for wordlist, place in db
def createWordnetInstDB(wordlist):
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

#print words that are instances of the ones in wordlist
def printWordnetInst(wordlist):

	for word in wordlist:
		
		data = wn.synsets(word,pos=wn.NOUN)
		associated_words = []
		for f in data:
			associated_words += list(set([w for s in f.closure(lambda s:s.hyponyms()) for w in s.lemma_names]))
		#print word,":",",".join(associated_words)
		print ",".join(associated_words) + ","
	print "Done"


#get words that are instances of the ones in wordlist
def getWordnetInst(wordlist):
	results = {}
	for word in wordlist:
		data = wn.synsets(word,pos=wn.NOUN)
		associated_words = []
		for f in data:
			associated_words += list(set([w for s in f.closure(lambda s:s.hyponyms()) for w in s.lemma_names]))
		results[word] = associated_words
	return results


#create files for each word found for a category
def getVectors(word):
	print "a) Staring getVectors: ",word
	assoc_words = getWordnetInst([word])
	wordnet_instances = set(assoc_words[word])
	print "b) Wordnet contains ",len(wordnet_instances)," instances of ",word 
	
	DBLOC     = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews.db'
	WORDLOC   = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsWords.txt'
	OUTPUTDIR = '/misc/vlgscratch3/FergusGroup/rahul/vectors/custVectors/'
	
	#all three million words
	f = open(WORDLOC,'r')
	all_words = set([line.strip() for line in f.readlines()])
	f.close()
	
	matched_words = []
	n = 0
	for w in all_words:
		n = n + 1
		if np.mod(n,100000)==0:
			print "\tProcessed ",n," # of instances of word:" ,len(matched_words)
		if w in wordnet_instances or w[:-1] in wordnet_instances:
			matched_words.append(w)
	print "c) Found ",len(matched_words)," matches"
	
	print "d) Constructing Vector Matrix"
	X = np.zeros((len(matched_words),300))
	db_vec = shelve.open(DBLOC)
	idx = 0
	for w in matched_words:
		X[idx,:]=np.array(db_vec[w].todense())
		idx = idx + 1
	db_vec.close()
	
	print "e) Saving matrix"
	np.savetxt(OUTPUTDIR+word+'.wnvec',X,'%.8f',delimiter=',')
	print "f) Done getVectors"
	return wordnet_instances,matched_words

if __name__ == '__main__':
	wordlist = ['movies', 'languages', 'computer', 'fruit', 'animal', 'people', 'vehicle', 'actions', 'food']
	result= getVectors('movies')
	(a,b) = result
	print a
	print b
