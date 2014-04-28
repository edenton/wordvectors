clear all
load generated_mats/all_google_words.mat;
fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
idx = 1;
country_words = {};
country_indices = [];
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
    w = line{2};
    country_words = [country_words, w];
    w = line{4};
    country_words = [country_words, w];
    line = fgetl(fid);
end
country_words = unique(country_words);
for i = 1 : length(country_words)
   country_indices(i) = find(ismember(words, country_words(i))); 
end
save('generated_mats/country_words_and_indices.mat', 'country_words', 'country_indices');
