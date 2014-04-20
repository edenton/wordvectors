import os

#CALL with python train_models.py 

#corpus_loc : corpus to train on 
#output_model_directory: where the models,words and vectors will be placed
#binary_loc : location of the binary
def trainModels(corpus_loc,output_directory,binary_loc):
	if not os.path.exists(output_directory):
		os.makedirs(output_directory)
	assert (os.path.isabs(corpus_loc) and os.path.isabs(output_directory) and os.path.isabs(binary_loc)),"Path provided is not an absolute path. Recheck."
	model_dir = output_directory + '/model/'
	data_dir   = output_directory + '/data/'
	if not os.path.exists(model_dir):
		os.makedirs(model_dir)
	if not os.path.exists(data_dir):
		os.makedirs(data_dir)

	print "Training Now."

	
	uid = 'skip-gram'
	print uid
	cmd = 'time '+binary_loc+' -train '+corpus_loc+' -output-orig '+model_dir+uid+'-vectors_and_vocab.bin -output-vector '+data_dir+uid+'-vectors.txt -output-vocab '+data_dir+uid+'-vocab.txt -cbow 0 -size 300 -window 10 -negative 0 -hs 1 -sample 1e-3 -threads 15 -binary 1' 
	print "Training Skip Gram"
	os.system(cmd)


	uid = 'cbow'
	print uid
	cmd = 'time '+binary_loc+' -train '+corpus_loc+' -output-orig '+model_dir+uid+'-vectors_and_vocab.bin -output-vector '+data_dir+uid+'-vectors.txt -output-vocab '+data_dir+uid+'-vocab.txt -cbow 1 -size 300 -window 5 -negative 0 -hs 1 -sample 1e-3 -threads 15 -binary 1' 
	print "Training CBOW"
	os.system(cmd)
	print "Done Training.."

if __name__== '__main__':
	CORPUSLOC = '/misc/vlgscratch3/FergusGroup/rahul/corpus/FINAL_CORPUS'
	TEST_CORPUSLOC = '/misc/vlgscratch3/FergusGroup/rahul/corpus/raw_data/text8'
	OUTPUTDIR  = '/misc/vlgscratch3/FergusGroup/rahul/trainingOUTPUTDIR'
	BINARYLOC  = '/home/rahul/courses/mlcs/wordvectors/word2vec/word2vec'
	trainModels(TEST_CORPUSLOC,OUTPUTDIR,BINARYLOC)
