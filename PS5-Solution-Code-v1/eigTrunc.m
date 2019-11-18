function [A_, b_, c_, sys] = eigTrunc(A, b, c, q)
  % Inputs
  % d/dt x = Ax + bu(t)
  % y = c^T x
  %
  % A: system matrix
  % b: u(t) multipliers
  % c: output selection vector
  % q: number of vectors to include in reduced model
  %
	% Eigenvector truncation MOR

  % Compute eigenvalues and eigenvectors
  [V, D] = eig(A);

  % Rotate b and c in eigenvector space
  b_ = V.'*b;
  c_ = c.'*V;

  % Check |c_i*b_i/lambda_i|
  metric = c_.'.*b_./diag(D);
  metric = abs(metric);
  [~, I] = sort(metric, 'descend');

  % Select important vectors
  Vq = V(:, I(1:q));

  % Reduce equation to q x q
  A_ = Vq.'*A*Vq;
  b_ = Vq.'*b;
  c_ = c.'*Vq;

  % Calculate frequency response
  sys = ss(A_, b_, c_, 0);

end
