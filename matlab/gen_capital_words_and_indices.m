clear all
load generated_mats/all_google_words.mat;
fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
idx = 1;
capital_words = {};
capital_indices = [];
while line ~= -1
    if mod(idx, 100) == 0
        fprintf(' -- %d --\n', idx);
    end   
    line = strsplit(line, ' ');
    if line{1} == ':'
        if strcmp(line{2}, 'capital-common-countries')
            line = fgetl(fid);
           continue
        else
            break
        end
    end
    w = line{1};
    capital_words = [capital_words, w];
    w = line{3};
    capital_words = [capital_words, w];
    line = fgetl(fid);
end
capital_words = unique(capital_words);
for i = 1 : length(capital_words)
   capital_indices(i) = find(ismember(words, capital_words(i))); 
end
save('generated_mats/capital_words_and_indices.mat', 'capital_words', 'capital_indices');
