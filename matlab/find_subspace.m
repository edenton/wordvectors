function [proj_mat, Q] = find_subspace(X, rank)
     
  tolerance = 0.15;
  % Compute SVD decomposition
  [u, s, v] = svd(X);
  
  % rank == -1 => find best rank
  if rank == -1
    for k = 1 : size(X, 1)
        Xapprox = u(:, 1:k) * s(1:k, 1:k) * v(:, 1:k)';
        err = norm(X(:) - Xapprox(:)) / norm(X(:));
        if err < tolerance
            break
        end
    end
  else 
    k = rank;
  end
  Xapprox = u(:, 1:k) * s(1:k, 1:k) * v(:, 1:k)';
  err = norm(X(:) - Xapprox(:)) / norm(X(:));
  fprintf('Approximation error with rank %d : ||X - Xapprox|| / ||X|| = %f\n', k, err);

  % Find a basis for the subspace the approximated points lie on
  Q = orth(Xapprox);
  proj_mat = Q * Q';

end
