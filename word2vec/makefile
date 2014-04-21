CC = gcc
#The -Ofast might not work with older versions of gcc; in that case, use -O2
CFLAGS = -lm -pthread -O2 -march=native -Wall -funroll-loops -Wno-unused-result

all: word2vec word2phrase distance my_distance nearest_words word-analogy compute-accuracy

word2vec : word2vec.c
	$(CC) word2vec.c -o word2vec $(CFLAGS)
word2phrase : word2phrase.c
	$(CC) word2phrase.c -o word2phrase $(CFLAGS)
distance : distance.c
	$(CC) distance.c -o distance $(CFLAGS)
my_distance : my_distance.c
	$(CC) my_distance.c -o my_distance $(CFLAGS)
nearest_words : nearest_words.c
	$(CC) nearest_words.c -o nearest_words $(CFLAGS)
word-analogy : word-analogy.c
	$(CC) word-analogy.c -o word-analogy $(CFLAGS)
compute-accuracy : compute-accuracy.c
	$(CC) compute-accuracy.c -o compute-accuracy $(CFLAGS)
	chmod +x *.sh

clean:
	rm -rf word2vec word2phrase distance my_distance nearest_words word-analogy compute-accuracy 
