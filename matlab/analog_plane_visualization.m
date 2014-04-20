clear all;
load generated_mats/analog_word_vectors.mat
load generated_mats/analog_word_words.mat
X = X'; % D x N

fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
while line ~= -1
    line = strsplit(line, ' ');
    if line{1} ~= ':'
        % Find 2D subspace the first 3 analogical reasoning words lie on
        line_indices = find(ismember(words, line));
        query = X(:, line_indices(1:3));
        answer = X(:, line_indices(4));
        pred = query(:, 1) - query(:, 2) + query(:, 3);
        [proj_mat, Q] = find_subspace(query, 2);
        
        % Project query, asnwer and rest of vectors using projection mat
        query_approx = proj_mat * query;
        answer_approx = proj_mat * answer;
        Xapprox = proj_mat * X;
        pred_approx = proj_mat * pred;
        
        % Compute distances from answer
        dist_from_plane = sum((X - Xapprox) .^ 2); 
        [~, sorted_idx] = sort(dist_from_plane, 'ascend');
        Xapprox = Xapprox(:, sorted_idx(1:30));
        
        % Get 2D representation and scatter        
        query_2D = (query' * Q)';
        answer_2D = (answer' * Q)';
        Xapprox_2D = (X(:, sorted_idx(1:30))' * Q)';
        pred_2D = query_2D(:, 1) - query_2D(:, 2) + query_2D(:, 3);
        hold on;
        scatter(Xapprox_2D(1, :), Xapprox_2D(2, :), 'g*');
        scatter(query_2D(1, :), query_2D(2, :), 'r.');
        scatter(answer_2D(1, :), answer_2D(2, :), 'r*');
        scatter(pred_2D(1, :), pred_2D(2, :), 'b*');
        
        
    end
    line = fgetl(fid);
end
    