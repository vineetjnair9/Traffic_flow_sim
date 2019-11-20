function [xf, x] = newtonNdGMRES(fhand,x0,p,t)
% function newton1d(fhand,x0,itpause)
%
% INPUTS:
%   fhand - function handle
%   x0 - initial guess
%   itpause - parameter for plotting
%
% Use Newton's method to solve the nonlinear function
% defined by function handle fhand with initial guess x0.
% Returns solution xf and all intermediate solutions
% x = [x1...xk...xf].
%
% itpause is parameter for plotting and defines the
% number of Newton steps that are plotted sequentially
% pauses between sub-steps.

tolf = 1e-10;         % function convergence tolerance
tolx = 1e-8;          % step convergence tolerance
maxIters = 500;       % max # of iterations
x00 = x0;             % initial guess
epsilon = 0.001; 

% Newton loop
for iter = 1:maxIters
    f = fhand(x0,t);               % evaluate function
    % Finite difference Jacobian at each state & time
    %J = jacobian_finite_difference('human_car_behaviour_v5',x0, p, 'constant_speed_input', t, epsilon);
    u = constant_speed_input(t);
    J = Jf_FiniteDifference('human_car_behaviour_v5',x0, p,u);
    dx = gmres(J,-f);
    nf(iter) = norm(f,Inf);      % norm of f at step k+1
    ndx(iter) = norm(dx,Inf);    % norm of dx at step k+1
    x(:,iter) = x0 + dx;         % solution x at step k+1
    x0 = x(:,iter);              % set value for next guess
    if nf(iter) < tolf && ndx(iter) < tolx % check for convergence
        fprintf('Converged in %d iterations\n',iter);
        break
    end
end
xf = x(:,iter);

if iter == maxIters % check for non-convergence
    fprintf('Non-Convergence after %d iterations!!!\n',iter);
end

x = [x00,x];
