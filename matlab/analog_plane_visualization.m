clear all;
load generated_mats/analog_word_words.mat
load generated_mats/analog_word_vectors.mat
X = X'; % D x N

to_keep = 30;
fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
while line ~= -1
    line = strsplit(line, ' ');
    if line{1} ~= ':'
        % Find 2D subspace the first 3 analogical reasoning words lie on
        line_indices = find(ismember(words, line));
        query = X(:, line_indices([1, 3, 4]));
        answer = X(:, line_indices(2));
        pred = query(:, 1) - query(:, 2) + query(:, 3);
        [proj_mat, Q] = find_subspace(query, 2);
        
        % Project query, asnwer and rest of vectors using projection mat
        query_approx = proj_mat * query;
        answer_approx = proj_mat * answer;
        Xapprox = proj_mat * X;
        pred_approx = proj_mat * pred;
        
        % Compute distances from answer
        dist_from_plane = sum((X - Xapprox) .^ 2) ./ sum((X) .^ 2); 
        [sorted_dist, sorted_idx] = sort(dist_from_plane, 'ascend');
        on_plane_indices = sorted_idx(1:to_keep);
        Xapprox = Xapprox(:, on_plane_indices);
        
        % Get 2D representation and scatter        
        query_2D = (query' * Q)';
        answer_2D = (answer' * Q)';
        Xapprox_2D = (X(:, on_plane_indices)' * Q)';
        pred_2D = query_2D(:, 1) - query_2D(:, 2) + query_2D(:, 3);
        
        % Plot some stuff
        hold on;
        scale = 5;
        % Compute cosine distance and higlight neighbours
        normalized_Xapprox_2D = bsxfun(@rdivide, Xapprox_2D, sqrt(sum( Xapprox_2D .^2 )));
        normalized_pred_2D = pred_2D / norm(pred_2D);
        dist_to_ans = 1 - (normalized_pred_2D' * normalized_Xapprox_2D);
        [sorted, closest_idx] = sort(dist_to_ans, 'ascend');
        K = 5;
        for k = 1 : K
           scatter(Xapprox_2D(1, closest_idx(k)), Xapprox_2D(2, closest_idx(k)), closest_idx(k)*scale*2, 'ro', 'filled');
        end
       
        for p = 1 : size(Xapprox_2D, 2)
            if sum(sorted_idx(p) == line_indices)
                continue;
            end
            scatter(Xapprox_2D(1, p), Xapprox_2D(2, p), scale*p, 'ko', 'filled');
        end   
        scatter(query_2D(1, :), query_2D(2, :), 40, 'r*');
        text(query_2D(1, 1) + .05, query_2D(2, 1), sprintf('%s (Q)', words{line_indices(1)}), 'FontSize', 15);
        text(query_2D(1, 2) + .05, query_2D(2, 2), sprintf('%s (Q)', words{line_indices(3)}), 'FontSize', 15);
        text(query_2D(1, 3) + .05, query_2D(2, 3), sprintf('%s (Q)', words{line_indices(4)}), 'FontSize', 15);
        scatter(answer_2D(1, :), answer_2D(2, :), p + find(sorted_idx == line_indices(2)) * scale, 'b.');
        text(answer_2D(1, 1) + .05, answer_2D(2, 1), sprintf('%s (GT)', words{line_indices(2)}), 'FontSize', 15);
        scatter(pred_2D(1, :), pred_2D(2, :), 40, 'r.');
        
        

        
        
        
    end
    line = fgetl(fid);
end
    