clear all;
load generated_mats/all_google_words.mat
load generated_mats/analog_question_indices.mat
fid = fopen('/misc/vlgscratch3/FergusGroup/denton/all_google_vectors.bin', 'rb');
X = fread(fid, [3000000, 300], 'single');
X = X'; % D x N

fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
correct_proj = 0;
total = 0;
K = 5;
to_keep = 20;
iter = 0;
ll = 1;
normalized_X = bsxfun(@rdivide, X, sqrt(sum( X .^2 )));
while line ~= -1
    line = strsplit(line, ' ');
    if line{1} ~= ':'
        iter = iter + 1;
        % Find 
        line_indices = analog_question_indices(ll, :);
        ll = ll + 1;
        answer_idx = line_indices(3);
        query_indices = line_indices([1, 2, 4]);
        query = X(:, query_indices);
        pred = query(:, 1) - query(:, 2) + query(:, 3);
        
        % Do prediction with projection
        [proj_mat, Q] = find_subspace(query, 2);
        Xapprox = proj_mat * X;
        pred_approx = proj_mat * pred;
        normalized_pred_approx = pred_approx / norm(pred_approx);
        
        % Only keep points close to subspace
        dist_from_plane = sum((X - Xapprox) .^ 2) ./ sum((X) .^ 2); 
        [~, sorted_idx] = sort(dist_from_plane, 'ascend');
        Xapprox = Xapprox(:, sorted_idx(1:to_keep));
        normalized_Xapprox = bsxfun(@rdivide, Xapprox, sqrt(sum( Xapprox .^2 )));
        dist_to_ans = 1 - (normalized_pred_approx' * normalized_Xapprox);
        [sorted, closest_idx] = sort(dist_to_ans, 'ascend');
        
        % Is correct answer in K-nearest set?
        if sum(ismember(sorted_idx(closest_idx(1:K)), answer_idx))
           correct_proj = correct_proj + 1; 
        end
        

        total = total + 1;
        
    end
    if iter > 0 && mod(iter, 10) == 0
        fprintf('%f%% (%d / %d)\n', 100 * correct_proj / total, correct_proj, total);
    end
    line = fgetl(fid);
end
    