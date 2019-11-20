function [x, r_norms] = mfgcr_shooting_FE(xk, params, b, tol, epsilon, maxiters,T)
% Matrix-free conjugate residual method for solving J*dx = b
% INPUTS
% fname - function handle
% xk - current estimate of x in Newton method
% b - right hand side
% tol - convergence tolerance, terminate on norm(b - J*dx) < tol * norm(b)
% maxiters - maximum number of iterations before giving up
% OUTPUTS
% x - computed solution, returns null if no convergence
% r_norms - the scaled norm of the residual at each iteration (r_norms(1) = 1)

timestep = 0.001; % (s)

% Generate the initial guess for x (zero)
x = zeros(size(b));

% Set the initial residual to b - Mx^0 = b
r = b;

% Determine the norm of the initial residual
r_norms(1) = norm(r,2);

%f0 = fname(xk);
n = ceil(T/timestep);
for iter = 1:maxiters
% Use the residual as the first guess for the new
% search direction and multiply by M
  p(:,iter) = r;
  phi1 = ForwardEuler('human_car_behaviour_v5',xk + epsilon * p(:,iter),params,'sinusoidal_input',0,T,timestep,false);
  phi2 = ForwardEuler('human_car_behaviour_v5',xk,params,'sinusoidal_input',0,T,timestep,false);
  phi1 = phi1(2,n);
  phi2 = phi2(2,n);
  
  Mp(:,iter) = (phi1 - phi2)/epsilon - p(:,iter);
  
  %Mp(:, iter) = (fname(xk+epsilon*p(:,iter)) - f0)/epsilon; % approximate product J*dx with finite difference

% Make the new Mp vector orthogonal to the previous Mp vectors,
% and the p vectors M^TM orthogonal to the previous p vectors
  for j = 1:iter-1
    beta = Mp(:,iter)' * Mp(:,j);
    p(:,iter) = p(:,iter) - beta * p(:,j);
    Mp(:,iter) = Mp(:,iter) - beta * Mp(:,j);
  end

% Make the orthogonal Mp vector of unit length, and scale the
% p vector so that M * p  is of unit length
  norm_Mp = norm(Mp(:,iter),2);
  Mp(:,iter) = Mp(:,iter)/norm_Mp;
  p(:,iter) = p(:,iter)/norm_Mp;

% Determine the optimal amount to change x in the p direction
% by projecting r onto Mp
  alpha = r' * Mp(:,iter);

% Update x and r
  x = x + alpha * p(:,iter);
  r = r - alpha * Mp(:,iter);

% Save the norm of r
  r_norms(iter+1) = norm(r,2);

% Print the norm during the iteration
% fprintf('||r||=%g i=%d\n', norms(iter+1), iter+1);

% Check convergence
  if r_norms(iter+1) < tol * r_norms(1)
    break
  end
end

% Notify user of convergence
if r_norms(iter+1) > tol * r_norms(1)
  fprintf(1, 'GCR NONCONVERGENCE!!!\n');
  x = [];
else
  % fprintf(1, 'GCR converged in %d iterations\n', iter);
end

% Scale the r_norms with respect to the initial residual norm
r_norms = r_norms / r_norms(1);
