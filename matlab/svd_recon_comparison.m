class1 = 'animal';
class2 = 'movies';

fname1 = sprintf('/misc/vlgscratch3/FergusGroup/rahul/vectors/custVectors/%s.wnvec', class1);
fname2 = sprintf('/misc/vlgscratch3/FergusGroup/rahul/vectors/custVectors/%s.wnvec', class2);

vectors1 = importdata(fname1); 
lim = ceil(size(vectors1, 1) * 0.75);
rperm = randperm(size(vectors1, 1));
X = vectors1(rperm(1 : lim), :)';
Xtest = vectors1(rperm(lim + 1 : end), :)';
vectors2 = importdata(fname2); Y = vectors2';
[D, ~] = size(X);

% Approximate class 1
[u, s, v] = svd(X);
k = 270;
Xapprox = u(:, 1:k) * s(1:k, 1:k) * v(:, 1:k)';
err = norm(X(:) - Xapprox(:)) / norm(X(:));
fprintf('||X - Xapprox|| / ||X|| = %f\n', err);

% Find a basis for the subspace the approximated points lie on
Q = orth(Xapprox);
assert(size(Q, 1) == D);
assert(size(Q, 2) == k);
proj_mat = Q * Q';

% Project remaing vectors from class 1 onto subspace 
Xtestapprox = proj_mat * Xtest; 
err = norm(Xtest(:) - Xtestapprox(:)) / norm(Xtest(:));
fprintf('||Xtest - Xtestapprox|| / ||Xtest|| = %f\n', err);

% Project class 2 onto the subspace
Yapprox = proj_mat * Y; 
err = norm(Y(:) - Yapprox(:)) / norm(Y(:));
fprintf('||Y - Yapprox|| / ||Y|| = %f\n', err);




