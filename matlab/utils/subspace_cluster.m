function [grps] = subspace_cluster(X, K)
% X: D x N matrix of N data points
% K: number of clusters

lambda = 0.001;
sparse_coeff = sparse_coef_recovery(X, 0, 'Lasso', lambda);
affinity_mat = build_adjacency(sparse_coeff, 0);

N = size(affinity_mat,1);

DKN = ( diag( sum(affinity_mat) ) )^(-1);
LapKN = speye(N) - DKN * affinity_mat;
[~, ~, vKN] = svd(LapKN);
f = size(vKN, 2);
kerKN = vKN(:, f-K+1 : f);
grps = kmeans(kerKN, K);
