function [errors, X] = svd_on_class(class)
% Compute the reconstrction error for uncreasing rank for a single class. It is assumed that the
% vector file for the class exists

		fname = sprintf('/misc/vlgscratch3/FergusGroup/rahul/vectors/custVectors/%s.wnvec', class);

		if exist('vectors', 'var') ~= 1
			vectors = importdata(fname);
		end
		X = vectors';
		[D, N] = size(X);

		[u, s, v] = svd(X);

		errors = [];
		for k = 1 : D
			Xapprox = u(:, 1:k) * s(1:k, 1:k) * v(:, 1:k)';
			err = norm(X(:) - Xapprox(:)) / norm(X(:));
			errors(end+1) = err;
			if errors(end) < 0.1 && errors(end-1) >= 0.1
				fprintf('------------------- rank %d ------------------------\n', k);
			end
			fprintf('%f\n', err);
		end
end
