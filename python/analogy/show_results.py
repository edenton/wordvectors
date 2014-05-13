

def show_results(resultsFile,qwFile,vocabFile):
	results = [[int(a) for a in t.strip().split(' ')] for t in open(resultsFile).readlines()]
	print len(results), (results[19543])
	ctr = 0
	words = [w.strip() for w in open(vocabFile).readlines()]
	for l in open(qwFile):
		print l.strip()
		if not ":" in l:
			print "\t",
			#print results[ctr],ctr
			for idx in results[ctr]:
				print words[idx-1],
			print "\n"
			ctr = ctr + 1

if __name__ == '__main__':
	qwFile = '/home/rahul/courses/mlcs/wordvectors/word2vec/questions-words.txt'
	'''
	resultsFile = '/home/rahul/courses/mlcs/wordvectors/python/wordnet/GoogleResults/results-googleVec.idx'
	vocabFile = '/misc/vlgscratch3/FergusGroup/rahul/vectors/GoogleNewsWords.txt'
	'''
	resultsFile = '/home/rahul/courses/mlcs/wordvectors/python/wordnet/CBOWResults/results-cbow.idx'
	vocabFile = '/misc/vlgscratch3/FergusGroup/rahul/trainingOUTPUTDIR/model/cbow-words.txt'

	resultsFile = '/home/rahul/courses/mlcs/wordvectors/python/wordnet/SkipGramResults/results-skip-gram.idx'
	vocabFile = '/misc/vlgscratch3/FergusGroup/rahul/trainingOUTPUTDIR/model/skip-gram-words.txt'
	

	show_results(resultsFile,qwFile,vocabFile)
