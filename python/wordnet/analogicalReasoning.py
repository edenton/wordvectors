import shelve
import numpy as np
DBLOC = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews.db'
QUESTION_LOC = '../../word2vec/questions-words.txt'
import os
VEC_FILE = '/home/rahul/courses/mlcs/wordvectors/python/wordnet/answer-vec.vec'
GRD_TRUTH = '/home/rahul/courses/mlcs/wordvectors/python/wordnet/answer-grdTruth.wd'
RESULT_FILE = '/home/rahul/courses/mlcs/wordvectors/python/wordnet/results'
NBRS  = 10
from itertools import izip
def setupShelve():
	#Test on analogical reasoning from shelve database
	db = shelve.open(DBLOC)
	err_lines = []	
	f_question = open(QUESTION_LOC,'r')

	
	
	f_answer   = open(VEC_FILE,'w')
	f_truth    = open(GRD_TRUTH,'w')
	can_test = float(0)
	total = float(0)
	print "Doing vector algebra for:"
	for l in f_question:
		line = l.strip()
		if line.startswith(":"):
			print "\tCategory: ",line
		else:
			words = line.split(' ')
			if 	words[0] in db and \
				words[1] in db and \
				words[2] in db and \
				words[3] in db:
				v_a=db[words[0]]
				v_b=db[words[1]]
				v_c=db[words[2]]
				res = v_b.toarray()[0]-v_a.toarray()[0]+v_c.toarray()[0]
				np.savetxt(f_answer,np.reshape(res,(1,300)),fmt='%.9f',delimiter=',')
				f_truth.write(words[3]+"\n")
				can_test +=1
		total +=1
	db.close()
	f_answer.close()
	f_question.close()
	f_truth.close()
	print "For the Analogical Reasoning Text, we can test the accuracy on ",(can_test*100/total),"% of words"

def getNearestWords():
	print "Computing nearest words..."
	BINFILE = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews-vectors-negative300.bin'
	cmd = '../../word2vec/nearest_words '+BINFILE+' '+str(NBRS)+' '+VEC_FILE+' '+RESULT_FILE 
	os.system(cmd)

def testSolutions():
	print "Computing accuracy:"
	acc_k = [0]*NBRS
	n=0
	with open(RESULT_FILE+'.wd') as t1, open(GRD_TRUTH) as t2: 
		for results, truth in izip(t1, t2):
			val = truth.strip()
			elems = [e.strip() for e in results.strip().split('|')]
			for k in range(1,NBRS):
				if val in elems[:k]:
					acc_k[k] +=1
			n+=1
	for k in range(1,NBRS):
		print "Test Accuracy: Top ",k," Accuracy= ",float(acc_k[k])*100/n," %" 

if __name__ == "__main__":
	#setupShelve()
	testSolutions()
# ./nearest_words /misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews-vectors-negative300.bin 12 /home/rahul/courses/mlcs/wordvectors/python/wordnet/input_file /home/rahul/courses/mlcs/wordvectors/python/wordnet/output_file
