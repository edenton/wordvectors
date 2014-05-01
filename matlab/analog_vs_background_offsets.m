clear all;
fid = fopen('/misc/vlgscratch3/FergusGroup/denton/all_google_vectors.bin', 'rb');
X = fread(fid, [3000000, 300], 'single');
X = X'; % D x N
fclose(fid);
normalized_X = bsxfun(@rdivide, X, sqrt(sum( X .^2 )));
load generated_mats/all_google_words.mat

load generated_mats/analog_question_indices.mat;

fname = '../word2vec/questions-words.txt';
fid = fopen(fname, 'r');
line = fgetl(fid);
ll = 1;
dd = 1;

offsets = [];
analog_distances = [];
while line ~= -1
    line = strsplit(line, ' ');
    if line{1} == ':'
        if ~isempty(offsets)
            N = size(offsets, 2);
            fprintf('Computing cosine distances for analogical section %d (%d x %d)... ', dd, N, N);
            cos_dist = zeros(N, N);
            for i  = 1 : N                                                                              
                for j = i+1 : N                                                                               
                    cos_dist(i, j) = 1 - offsets(:, i)' * offsets(:, j) / (norm(offsets(:, i)) * norm(offsets(:, j)));
                end
            end  
            tmp = sort(cos_dist(:));
            tmp = unique(tmp(N*(N+1)/2:end));
            analog_distances = [analog_distances; tmp];
            offsets = [];
            fprintf('Done\n');
            dd = dd + 1;
        end
    else
        line_indices = analog_question_indices(ll, :);
        ll = ll + 1;
        offsets(:, end+1) = X(:, line_indices(1)) - X(:, line_indices(2));
        offsets(:, end+1) = X(:, line_indices(3)) - X(:, line_indices(4));
    end
    line = fgetl(fid);
end
fclose(fid);
save('generated_mats/analog_vs_background_offsets.mat', 'analog_distances');

% Generate background distances
rp = randperm(size(X, 2));
Nb = 50;
Nb = 50;
offsets = [];
for i = 1 : Nb
    for j = 1 : Nb
        offsets(:, end+1) = X(:, rp(i)) - X(:, rp(j));
    end
end
N = size(offsets, 2);
fprintf('Computing cosine distances for background... ', dd, N, N);
cos_dist = zeros(N, N);
for i  = 1 : N                                                                              
    for j = i+1 : N                                                                               
        cos_dist(i, j) = 1 - offsets(:, i)' * offsets(:, j) / (norm(offsets(:, i)) * norm(offsets(:, j)));
    end
end  
tmp = sort(cos_dist(:));
background_distances = unique(tmp(N*(N+1)/2:end));
fprintf('Done\n')

save('generated_mats/analog_vs_background_offsets.mat', 'analog_distances', 'background_distances');

figure(1)
[n1, x1] = hist(background_distances, 500);
[n2, x2] = hist(analog_distances, 500);
bar(x1, n1 / sum(n1), 'b'); hold on;
bar(x2, n2 / sum(n2), 'r');
legend('Randomly sampled offsets', 'Known analogical offsets')
