/*
Rahul G. Krishnan
Emily Denton
MLCS 2014
*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>

const long long max_size = 2000;         // max length of strings
const long long N = 100;                 // number of closest vectors to consider
const long long max_w = 50;              // max length of vocabulary entries

//Trim array for whitespace
char* trim(char *str)
{
    size_t len = 0;
    char *frontp = str - 1;
    char *endp = NULL;

    if( str == NULL )
            return NULL;

    if( str[0] == '\0' )
            return str;

    len = strlen(str);
    endp = str + len;

    /* Move the front and back pointers to address
     * the first non-whitespace characters from
     * each end.
     */
    while( isspace(*(++frontp)) );
    while( isspace(*(--endp)) && endp != frontp );

    if( str + len - 1 != endp )
            *(endp + 1) = '\0';
    else if( frontp != str &&  endp == frontp )
            *str = '\0';

    /* Shift the string so that it starts at str so
     * that if it's dynamically allocated, we can
     * still free it on the returned pointer.  Note
     * the reuse of endp to mean the front of the
     * string buffer now.
     */
    endp = str;
    if( frontp != str )
    {
            while( *frontp ) *endp++ = *frontp++;
            *endp = '\0';
    }


    return str;
}

int main(int argc, char **argv) 
{
  //File handles
  FILE *f;
  FILE *fout_idx;
  FILE *fout_words;
  FILE *fin;

  char st1[max_size];
  int NBRS;

  char file_name[max_size], out_file_name[max_size], input_file_name[max_size];
  
  float dist, len, bestd[N], vec[max_size];


  long long words, size, a, b, c, d;
  char ch;
  float *M;
  char *vocab;

  if (argc < 5) {
    printf("Usage: ./nearest_words <BIN_FILE> <# NBRS> <IN_FILE> <OUT_FILE>\n \
         BIN_FILE : words in BINARY FORMAT\n \
         # NBRS   : N: number of neighbors to consider in vector space\n \
         IN_FILE  : input file with K lines (one vector per line) in TXT format \"elem1,elem2,..\"\n \
         OUT_FILE : output file with K lines. One file contains indices(.idx), one contains words(.wd) Each line contains N elements of the form \"i1,i2..\" or \"w1,w2\" \n");
    return 0;
  }
  
  

  //Binary File
  strcpy(file_name, argv[1]);
  f = fopen(file_name, "rb");
  if (f == NULL) {
    printf("Binary file not found\n");
    return -1;
  }
  printf("Binary File: %s\n",file_name);
  
  //Number of Neighbors
  strcpy(st1, argv[2]);
  NBRS = atoi(st1);
  printf("Number of Neighbors: %d\n",NBRS);
  
  int bestidx[NBRS]; 
  char *bestw[NBRS];

  //Input File
  strcpy(input_file_name, argv[3]);
  fin = fopen(input_file_name,"r");
  if (fin==NULL){
    printf("Input file not found\n");
  }
  printf("Input File: %s\n",input_file_name);

  //Create output file to write to 
  strcpy(out_file_name, argv[4]);
  fout_idx = fopen(strcat(out_file_name,".idx"), "w");
  if (fout_idx == NULL) {
    printf("Idx file not created\n");
    return -1;
  }
  printf("Index Output File: %s\n",out_file_name);

  //Create output file to write to 
  strcpy(out_file_name, argv[4]);
  fout_words = fopen(strcat(out_file_name,".wd"), "w");
  if (fout_words == NULL) {
    printf("Word file not found\n");
    return -1;
  }
  printf("Index Output File: %s\n",out_file_name);

  // Load Vocabulary and mapping to vectors
  fscanf(f, "%lld", &words);
  fscanf(f, "%lld", &size);
  printf("Words: %lld, Size: %lld\n",words,size);
  

  printf("Loading vocabulary\n");
  vocab = (char *)malloc((long long)words * max_w * sizeof(char));
  for (a = 0; a < NBRS; a++) bestw[a] = (char *)malloc(max_size * sizeof(char));

  printf("Loading vectors\n");
  M = (float *)malloc((long long)words * (long long)size * sizeof(float));
  if (M == NULL) {
    printf("Cannot allocate memory: %lld MB    %lld  %lld\n", (long long)words * size * sizeof(float) / 1048576, words, size);
    return -1;
  }
  //Normalizes vectors
  
  printf("Normalizing Vectors\n");
  for (b = 0; b < words; b++) {
    fscanf(f, "%s%c", &vocab[b * max_w], &ch);
    for (a = 0; a < size; a++) fread(&M[a + b * size], sizeof(float), 1, f);
    len = 0;
    for (a = 0; a < size; a++) len += M[a + b * size] * M[a + b * size];
    len = sqrt(len);
    for (a = 0; a < size; a++) M[a + b * size] /= len;
  }
  
  fclose(f);
  // Done loading vocabulary


  char line [ size*20 ]; 
  char* token;
  int line_num = 0;
  printf("Reading input file.....\n");
  while(fgets ( line, sizeof line, fin ) != NULL)
  {  
  	
    for (a = 0; a < size; a++) vec[a] = 0;
    line_num +=1;
	printf(" ----------- Processing Input %d --------\n",line_num);
    //Tokenize line to get float values
    token = strtok (line,",");
    a=0;

    while (token != NULL)
    {

      vec[a] = atof(trim(token));
      //printf("%s : %f\n",token,vec[a]);
      a += 1;
      token = (char*)strtok (NULL, ",");
    }
    //for (a=0;a<size;a++) printf("%d: %f,",a,vec[a]);
    if (a!=size)
    {
      printf("Error. Index out of bounds\n");
      return -1;
    }
    printf("\tDone loading vec\n");
    //if (line_num==25) break;
    
    //initializing
    for (a = 0; a < NBRS; a++) bestidx[a] = 0;
    for (a = 0; a < NBRS; a++) bestd[a] = 0;
    for (a = 0; a < NBRS; a++) bestw[a][0] = 0;

    //Normalize vec
    len = 0;
    for (a = 0; a < size; a++) len += vec[a] * vec[a];
    len = sqrt(len);
    for (a = 0; a < size; a++) vec[a] /= len;


    for (a = 0; a < NBRS; a++) bestd[a] = -1;
    for (a = 0; a < NBRS; a++) bestw[a][0] = 0;

    printf("\tSearching for nearest vectors\n");
    for (c = 0; c < words; c++) 
    {
        dist = 0;
        for (a = 0; a < size; a++) dist += vec[a] * M[a + c * size];
        for (a = 0; a < NBRS; a++) 
        {
            if (dist > bestd[a]) 
            {
              for (d = NBRS - 1; d > a; d--) 
              {
                bestd[d] = bestd[d - 1];
                strcpy(bestw[d], bestw[d - 1]);
              }
              bestd[a] = dist;
              bestidx[a] = (int) c;
              strcpy(bestw[a], &vocab[c * max_w]);
              break;
            }
        }
    }

    printf("\tPrinting neighbors\n"); 
    for (a = 0; a < NBRS; a++) 
    {
      //printf("%50s\t\t%f\n", bestw[a], bestd[a]);
      //indices are printed with an extra one appended to them
      fprintf(fout_idx, "%d ", bestidx[a] + 1);
      fprintf(fout_words, "%s|", trim(bestw[a]));
    }
    fprintf(fout_words,"\n");
    fprintf(fout_idx, "\n");
  
  }

  fclose(fout_idx);
  fclose(fout_words);
  return 0;
}
