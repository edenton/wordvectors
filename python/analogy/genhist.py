#generate plots
import cPickle as pickle
f = open('cbow-analogy.pickle','rb')
data_cbow = pickle.load(f)
f.close()
