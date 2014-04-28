clear all
load generated_mats/all_google_words.mat;
fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
analog_question_indices = [];
idx = 1;
all_indices = 1 : length(words);
while line ~= -1
    if mod(idx, 100) == 0
        fprintf(' -- %d --\n', idx);
        save('generated_mats/analog_question_indices.mat', 'analog_question_indices');
    end   
    line = strsplit(line, ' ');
    if line{1} ~= ':'

        % Find 2D subspace the first 3 analogical reasoning words lie on
        line_indices = zeros(1, 4);
        for ii = 1 : 4
            line_indices(ii) = find(ismember(words, line(ii)));
        end
        analog_question_indices(idx, :) = line_indices;

        idx = idx + 1;
    end
    line = fgetl(fid);
end
fclose(fid);

save('generated_mats/analog_question_indices.mat', 'analog_question_indices');
        