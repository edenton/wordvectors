#generate plots
import cPickle as pickle
import matplotlib.pyplot as plt
import numpy as np
plt.rc('xtick', labelsize=17) 
plt.rc('ytick', labelsize=17) 
plt.rcParams['legend.loc'] = 'best'
plt.rcParams['legend.fontsize'] = 25
from matplotlib.backends.backend_pdf import PdfPages
plt.rcParams['figure.figsize'] = 35, 15

f = open('cbow-analogy.pickle','rb')
data_cbow = pickle.load(f)
f.close()

f = open('skip-gram-analogy.pickle','rb')
data_skip_gram = pickle.load(f)
f.close()

f = open('GoogleVec-analogy.pickle','rb')
data_googlevec= pickle.load(f)
f.close()



s_num = 421
sections_picked = [3,6,7,8,9,10,11,12]
sectionNames = [t.strip().split(' ')[1] for t in open('sectionsAnalogicalReasoning.txt').readlines()]

plt.figure(1)
x_axis = range(11)
plt.title('Top K Accuracy on Sections in Analogical Reasoning')


for idx in range(len(sections_picked)):
	print "Plotting in ",s_num+idx
	plt.subplot(s_num+idx)
	plt.plot(x_axis, np.array(data_googlevec[sections_picked[idx]+1]), 'b',label='googleVec')
	plt.plot(x_axis, np.array(data_cbow[sections_picked[idx]+1]), 'r',label='cbow')
	plt.plot(x_axis, np.array(data_skip_gram[sections_picked[idx]+1]), 'g',label='skip-gram')
	plt.title(sectionNames[idx].split("questions-")[1],fontsize=30)
	plt.xlabel('k',fontsize=17)
	plt.ylabel('% Accuracy',fontsize=22)
	plt.legend()


pp = PdfPages('sections-results.pdf')
plt.savefig(pp,format='pdf')
pp.close()
plt.show()