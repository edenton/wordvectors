//  Copyright 2013 Google Inc. All Rights Reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>

const long long max_size = 2000;         // max length of strings
const long long N = 100;                  // number of closest words that will be shown
const long long max_w = 50;              // max length of vocabulary entries

int main(int argc, char **argv) {
  FILE *f;
  FILE *fout;
  char st1[max_size];
  char *bestw[N];
  char file_name[max_size], out_file_name[max_size];
  float dist, len, bestd[N], vec[max_size];
  int bestidx[N]; 
  long long words, size, a, b, c, d;
  char ch;
  float *M;
  char *vocab;
  if (argc < 4) {
    printf("Usage: ./distance <WORD> <IN_FILE> <OUT_FILE>\nwhere IN_FILE contains word projections in the BINARY FORMAT\n");
    return 0;
  }
  strcpy(st1, argv[1]);
  strcpy(file_name, argv[2]);
  f = fopen(file_name, "rb");
  if (f == NULL) {
    printf("Input file not found\n");
    return -1;
  }
  strcpy(out_file_name, argv[3]);
  fout = fopen(out_file_name, "a");
  if (fout == NULL) {
    printf("Output file not found\n");
    return -1;
  }

  fscanf(f, "%lld", &words);
  fscanf(f, "%lld", &size);
  vocab = (char *)malloc((long long)words * max_w * sizeof(char));
  for (a = 0; a < N; a++) bestw[a] = (char *)malloc(max_size * sizeof(char));
  M = (float *)malloc((long long)words * (long long)size * sizeof(float));
  if (M == NULL) {
    printf("Cannot allocate memory: %lld MB    %lld  %lld\n", (long long)words * size * sizeof(float) / 1048576, words, size);
    return -1;
  }
  for (b = 0; b < words; b++) {
    fscanf(f, "%s%c", &vocab[b * max_w], &ch);
    for (a = 0; a < size; a++) fread(&M[a + b * size], sizeof(float), 1, f);
    len = 0;
    for (a = 0; a < size; a++) len += M[a + b * size] * M[a + b * size];
    len = sqrt(len);
    for (a = 0; a < size; a++) M[a + b * size] /= len;
  }
  fclose(f);
  for (a = 0; a < N; a++) bestidx[a] = 0;
  for (a = 0; a < N; a++) bestd[a] = 0;
  for (a = 0; a < N; a++) bestw[a][0] = 0;

  for (b = 0; b < words; b++) if (!strcmp(&vocab[b * max_w], st1)) break;
  if (b == words) b = -1;
  printf("\nWord: %s  Position in vocabulary: %lld\n", st1, b);
  if (b == -1) {
    printf("Out of dictionary word!\n");
    return -1;
  }
  // Print word index that we're searching for
  fprintf(fout, "%d\n", b + 1 );
  printf("\n                                              Word       Cosine distance\n------------------------------------------------------------------------\n");
  for (a = 0; a < size; a++) vec[a] = 0;
  for (a = 0; a < size; a++) vec[a] += M[a + b * size];
  len = 0;
  for (a = 0; a < size; a++) len += vec[a] * vec[a];
  len = sqrt(len);
  for (a = 0; a < size; a++) vec[a] /= len;
  for (a = 0; a < N; a++) bestd[a] = -1;
  for (a = 0; a < N; a++) bestw[a][0] = 0;
  for (c = 0; c < words; c++) {
      a = 0;
    if (b == c) a = 1;
    if (a == 1) continue;
    dist = 0;
    for (a = 0; a < size; a++) dist += vec[a] * M[a + c * size];
    for (a = 0; a < N; a++) {
      if (dist > bestd[a]) {
        for (d = N - 1; d > a; d--) {
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
  for (a = 0; a < N; a++) {
    printf("%50s\t\t%f\n", bestw[a], bestd[a]);
    fprintf(fout, "%d\n", bestidx[a] + 1 );
  }
  fclose(fout);
  return 0;
}
