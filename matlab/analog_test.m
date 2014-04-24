clear all;
load generated_mats/all_google_words.mat
fid = fopen('/misc/vlgscratch3/FergusGroup/denton/all_google_vectors.bin', 'rb');
X = fread(fid, [3000000, 300], 'single');
X = X'; % D x N

fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
correct = 0;
total = 0;
K = 5;
iter = 0;
normalized_X = bsxfun(@rdivide, X, sqrt(sum( X .^2 )));
while line ~= -1
    line = strsplit(line, ' ');
    if line{1} ~= ':'
        iter = iter + 1;
        % Do original predition using nearest neighbours search (using cosine distance)
        line_indices = find(ismember(words, line));
        answer_idx = line_indices(3);
        query_indices = line_indices([1, 2, 4]);
        query = X(:, query_indices);
        answer = X(:, answer_idx);
        pred = query(:, 1) - query(:, 2) + query(:, 3);
        normalized_pred = pred / norm(pred);
        dist_to_ans = 1 - (normalized_pred' * normalized_X);
        [sorted, closest_idx] = sort(dist_to_ans, 'ascend');
        
        % Is correct answer in K-nearest set?
        if sum(ismember(closest_idx(1:K), answer_idx))
           correct = correct + 1; 
        end

        total = total + 1;
        
    end
    if iter > 0 && mod(iter, 25) == 0
        fprintf('%f%% (%d / %d)\n',  100 * correct / total, correct, total);
    end
    line = fgetl(fid);
end