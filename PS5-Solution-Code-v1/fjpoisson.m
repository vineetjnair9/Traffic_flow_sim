function [F, J] = fjpoisson(psi,t,N,V)

  dx = 1/(N+1);  % bar length divided by number of segments

  A = toeplitz([-2 1 zeros(1,N-2)]);        % second difference matrix
  F = A*psi/dx^2 - (exp(psi) - exp(-psi));  % calculate F at each point
  F(1) = F(1) - V/dx^2;                     % apply left BC
  F(end) = F(end) + V/dx^2;                 % apply right BC

  J = A/dx^2 - diag((exp(psi) + exp(-psi)));
  % Jacobian of linear part of F, A*psi, is simply A
  % Nonlinear part of F_i only depends on psi_i, so its contribution to the Jacobian is diagonal

end
