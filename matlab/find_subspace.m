function [proj_mat, Q] = find_subspace(X, rank)
     
  % Compute SVD decomposition
  [u, s, v] = svd(X);
  k = rank;
  Xapprox = u(:, 1:k) * s(1:k, 1:k) * v(:, 1:k)';
  err = norm(X(:) - Xapprox(:)) / norm(X(:));
  fprintf('Approximation error with rank %d : ||X - Xapprox|| / ||X|| = %f\n', k, err);

  % Find a basis for the subspace the approximated points lie on
  Q = orth(Xapprox);
  proj_mat = Q * Q';

end
