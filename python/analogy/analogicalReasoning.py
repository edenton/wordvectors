import shelve
import numpy as np
import os
from scipy.io import savemat
import cPickle as pickle

DATA_HOME = '/misc/vlgscratch3/FergusGroup/rahul/'
QUESTION_LOC = '../../word2vec/questions-words.txt'

DATASETNAME= 'GoogleVec'
DBLOC = DATA_HOME+'vectors/GoogleNews.db'
BINFILE = DATA_HOME + 'vectors/GoogleNews-vectors-negative300.bin'
VEC_FILE = '/home/rahul/courses/mlcs/wordvectors/python/analogy/GoogleResults/googleVec-answer-vec.vec'
GRD_TRUTH = '/home/rahul/courses/mlcs/wordvectors/python/analogy/GoogleResults/googleVec-answer-grdTruth.wd'
RESULT_FILE = '/home/rahul/courses/mlcs/wordvectors/python/analogy/GoogleResults/results-googleVec'
'''
DATASETNAME= 'skip-gram'
DBLOC = DATA_HOME+'trainingOUTPUTDIR/model/skip-gram.db'
BINFILE = DATA_HOME + 'trainingOUTPUTDIR/model/skip-gram-vectors_and_vocab.bin'
VEC_FILE = '/home/rahul/courses/mlcs/wordvectors/python/analogy/SkipGramResults/skip-gram-answer-vec.vec'
GRD_TRUTH = '/home/rahul/courses/mlcs/wordvectors/python/analogy/SkipGramResults/skip-gram-answer-grdTruth.wd'
RESULT_FILE = '/home/rahul/courses/mlcs/wordvectors/python/analogy/SkipGramResults/results-skip-gram'


DATASETNAME= 'cbow'
DBLOC = DATA_HOME+'trainingOUTPUTDIR/model/cbow.db'
BINFILE = DATA_HOME + 'trainingOUTPUTDIR/model/cbow-vectors_and_vocab.bin'
VEC_FILE = '/home/rahul/courses/mlcs/wordvectors/python/analogy/CBOWResults/cbow-answer-vec.vec'
GRD_TRUTH = '/home/rahul/courses/mlcs/wordvectors/python/analogy/CBOWResults/cbow-answer-grdTruth.wd'
RESULT_FILE = '/home/rahul/courses/mlcs/wordvectors/python/analogy/CBOWResults/results-cbow'

'''

NBRS  = 10
from itertools import izip
def setupShelve():
	#Test on analogical reasoning from shelve database
	db = shelve.open(DBLOC)
	err_lines = []	
	f_question = open(QUESTION_LOC,'r')

	
	
	f_answer   = open(VEC_FILE,'w',0)
	f_truth    = open(GRD_TRUTH,'w',0)
	can_test = float(0)
	total = float(0)
	print "Doing vector algebra for:"
	for l in f_question:
		line = l.strip()
		if line.startswith(":"):
			print "\tCategory: ",line
		else:
			words = line.split(' ')
			#print words
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
	cmd = '../../word2vec/nearest_words '+BINFILE+' '+str(NBRS)+' '+VEC_FILE+' '+RESULT_FILE 
	print cmd
	#os.system(cmd)

def testSolutions():
	print "Computing accuracy:"
	acc_k = [0]*(NBRS+1)
	n=0
	print "Results from ",DBLOC
	with open(RESULT_FILE+'.wd') as t1, open(GRD_TRUTH) as t2: 
		for results, truth in izip(t1, t2):
			val = truth.strip()
			elems = [e.strip() for e in results.strip().split('|')]
			for k in range(1,NBRS+1):
				if val in elems[:k]:
					acc_k[k] +=1
			n+=1
	for k in range(1,NBRS+1):
		print "Test Accuracy: Top ",k," Accuracy= ",float(acc_k[k])*100/n," %" 


def testSolutionsPerSection():
	#print "Computing accuracy:"
	acc_k = [0]*(NBRS+1)
	
	#print "Results from ",DBLOC
	f = open('sectionsAnalogicalReasoning.txt')

	n=0
	tmp = f.readline()
	sectionSize = int(tmp.strip().split(' ')[0])
	sectionName = tmp.strip().split(' ')[1]
	sectionNum  = 1
	h_data = {}
	h_name = {}
	with open(RESULT_FILE+'.wd') as t1, open(GRD_TRUTH) as t2:
		for results, truth in izip(t1, t2):
			val = truth.strip()
			elems = [e.strip() for e in results.strip().split('|')]
			for k in range(1,NBRS+1):
				if val in elems[:k]:
					acc_k[k] +=1
			n+=1
			if n==sectionSize:
				#print "\nSection : ",sectionName," Section Size: ",sectionSize
				#print "---------------------------------------------------"
				print sectionName
				acc = [0]*(NBRS+1)
				for k in range(1,NBRS+1):
					#print "Test Accuracy: Top ",k," Accuracy= ",float(acc_k[k])*100/float(sectionSize)," %"
					acc[k] = float(acc_k[k])*100/float(sectionSize)
					print k,acc[k]
				h_data[sectionNum] = acc
				h_name[sectionNum] = sectionName

				acc_k = [0]*(NBRS+1)
				n=0
				tmp = f.readline()
				if tmp !='':
					sectionSize = int(tmp.strip().split(' ')[0])
					sectionName = tmp.strip().split(' ')[1]
					sectionNum = sectionNum + 1
	f.close()
	f = open(DATASETNAME+'-analogy.pickle','wb')
	pickle.dump(h_data,f)
	f.close()

if __name__ == "__main__":
	#setupShelve() 
	#getNearestWords()
	testSolutionsPerSection()
# ./nearest_words /misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNews-vectors-negative300.bin 12 /home/rahul/courses/mlcs/wordvectors/python/wordnet/input_file /home/rahul/courses/mlcs/wordvectors/python/wordnet/output_file
