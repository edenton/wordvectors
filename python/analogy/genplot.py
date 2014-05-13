#generate plots
import cPickle as pickle
import matplotlib.pyplot as plt

f = open('cbow-analogy.pickle','rb')
data_cbow = pickle.load(f)
f.close()

f = open('skip-gram-analogy.pickle','rb')
data_skip_gram = pickle.load(f)
f.close()

f = open('GoogleVec-analogy.pickle','rb')
data_googlevec= pickle.load(f)
f.close()

data = [() for (a,b,c) in izip(data_googlevec,data_cbow,data_skip_gram)]

sections = [t.strip().split(' ')[1] for t in open('sectionsAnalogicalReasoning.txt').readlines()]
