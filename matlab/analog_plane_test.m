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
        % Find 2D subspace the first 3 analogical reasoning words lie on
        line_indices = zeros(1, 4);
        for ii = 1 : 4
            line_indices(ii) = find(ismember(words, line(ii)));
        end
        answer_idx = line_indices(3);
        query_indices = line_indices([1, 2, 4]);
        query = X(:, query_indices);
        answer = X(:, answer_idx);
        pred = query(:, 1) - query(:, 2) + query(:, 3);
        [proj_mat, Q] = find_subspace(query, 2);
        
        % Project query, asnwer and rest of vectors using projection mat
        query_approx = proj_mat * query;
        answer_approx = proj_mat * answer;
        Xapprox = proj_mat * X;
        pred_approx = proj_mat * pred;
        
        % Compute distances from answer
        dist_from_plane = sqrt(sum((X - Xapprox) .^ 2)) ./ sqrt(sum((X) .^ 2)); 
        [sorted_dist, sorted_idx] = sort(dist_from_plane, 'ascend');
        on_plane_indices = sorted_idx(1:to_keep);
        if sum(on_plane_indices == answer_idx) == 0
            fprintf('Answer too far from plane: %f\n', dist_from_plane(answer_idx));
        end
        Xapprox = Xapprox(:, on_plane_indices);
        
        % Get 2D representation and scatter        
        query_2D = (query' * Q)';
        answer_2D = (answer' * Q)';
        Xapprox_2D = (X(:, on_plane_indices)' * Q)';
        pred_2D = query_2D(:, 1) - query_2D(:, 2) + query_2D(:, 3);
        
        normalized_Xapprox_2D = bsxfun(@rdivide, Xapprox_2D, sqrt(sum( Xapprox_2D .^2 )));
        normalized_pred_2D = pred_2D / norm(pred_2D);
        dist_to_ans = 1 - (normalized_pred_2D' * normalized_Xapprox_2D);
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
    