clear all;
load generated_mats/analog_word_vectors.mat
load generated_mats/analog_word_words.mat
X = X'; % D x N

fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
sum_correct = 0;
K = 5;
while line ~= -1
    line = strsplit(line, ' ');
    if line{1} ~= ':'
        % Find 2D subspace the first 3 analogical reasoning words lie on
        line_indices = find(ismember(words, line));
        answer_idx = line_indices(4);
        query_indices = line_indices(1:3);
        query = X(:, query_indices);
        answer = X(:, answer_idx);
        pred = query(:, 1) - query(:, 2) + query(:, 3);

        % Do nearest neighbours search 
        dist_to_ans = sqrt(sum( bsxfun(@minus, X, pred) .^2 ));
        [sorted, closest_idx] = sort(dist_to_ans, 'ascend');
        
        % Is correct answer in K-nearest set?
        if (ismember(closest_idx(1:K), answer_idx))
           sum_correct = sum_correct + 1; 
        end
        
    end
    line = fgetl(fid);
end
    