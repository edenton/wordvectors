clear all;
fid = fopen('/misc/vlgscratch3/FergusGroup/denton/all_google_vectors.bin', 'rb');
X = fread(fid, [3000000, 300], 'single');
X = X'; % D x N
fclose(fid);

load generated_mats/all_google_words.mat

load generated_mats/analog_question_indices.mat;
analog_question_indices = analog_question_indices(1:10000, :);
idx_to_keep = unique(analog_question_indices(:));

XX = X(:, idx_to_keep);

[D, N] = size(XX);
offsets = zeros(D, N*N - N);
idx = 1;

for n1 = 1 : N
    for n2 = 1 : N
        if n1 ~= n2
            offsets(:, idx) = XX(:, n1) - XX(:, n2);
            idx = idx+1;
        end
    end
end

[~, N_pairs] = size(offsets);
cos_dist = zeros(N_pairs, N_pairs);
normalized_offsets = bsxfun(@rdivide, offsets, sqrt(sum(offsets.^2)));
for p1 = 1 : N_pairs
    for p2 = p1 + 1 : N_pairs
        cos_dist(p1, p2) = 1 - normalized_offsets(:, p1)' * normalized_offsets(:, p2);
    end
    if mod(p1, 100) == 0
        fprintf('p1 = %d\n', p1);
    end
end

sparse_cd = cos_dist;
sparse_cd(sparse_cd < 0.25) = 0;

