function [A_, b_, c_, sys] = pod(A, b, c, q, W)
  % Inputs
  % d/dt x = Ax + bu(t)
  % y = c^T x
  %
  % A: system matrix
  % b: u(t) multipliers
  % c: output selection vector
  % q: number of vectors to include in reduced model
  %
  % POD

  [U, ~, ~] = svd(W);

  Vq = U(:, 1:q);

  % Compute reduced model matrices
  A_ = Vq.'*A*Vq;
  b_ = Vq.'*b;
  c_ = c.'*Vq;

  % Calculate frequency response
  sys = ss(A_, b_, c_, 0);

end
