clear all
load generated_mats/all_google_words.mat;
fname = 'frequent_words.txt';
fid = fopen(fname, 'r');
idx = 1;
frequent_words = {};
frequent_indices = [];
line = fgetl(fid);
while line ~= -1
    fprintf('%d\n', idx);
    word = strrep(line, ' ', '');
    frequent_words = [frequent_words, word];
    line = fgetl(fid);
    idx = idx + 1;
end
frequent_indices = find(ismember(words, frequent_words));
frequent_words = words(frequent_indices);
save('generated_mats/frequent_words_and_indices.mat', 'frequent_words', 'frequent_indices');
