function [proj_mat, X, Xtest, Y] = svd_recon_comparison(class1, class2, rank, hold_out)

  fname1 = sprintf('/misc/vlgscratch3/FergusGroup/rahul/vectors/custVectors/%s.wnvec', class1);
  fname2 = sprintf('/misc/vlgscratch3/FergusGroup/rahul/vectors/custVectors/%s.wnvec', class2);

  vectors1 = importdata(fname1); 
  lim = ceil(size(vectors1, 1) * hold_out);
  rperm = randperm(size(vectors1, 1));
  X = vectors1(rperm(1 : lim), :)';
  Xtest = vectors1(rperm(lim + 1 : end), :)';
  vectors2 = importdata(fname2); Y = vectors2';
  [D, ~] = size(X);

  % Approximate class 1
  [proj_mat, Q] = find_subspace(X, rank);
  assert(size(Q, 1) == D);
  assert(size(Q, 2) == rank);


% Project original vecotors onto subspace
  Xapprox = proj_mat * X; 
  err = norm(X(:) - Xapprox(:)) / norm(X(:));
  fprintf('\n||X - Xapprox|| / ||X|| = %f\n', err);

  % Project remaing vectors from class 1 onto subspace 
  if length(Xtest) > 0
    Xtestapprox = proj_mat * Xtest; 
    err = norm(Xtest(:) - Xtestapprox(:)) / norm(Xtest(:));
    fprintf('||Xtest - Xtestapprox|| / ||Xtest|| = %f\n', err);
  end 
  % Project class 2 onto the subspace
  Yapprox = proj_mat * Y; 
  err = norm(Y(:) - Yapprox(:)) / norm(Y(:));
  fprintf('||Y - Yapprox|| / ||Y|| = %f\n', err);

end



