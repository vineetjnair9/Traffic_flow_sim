function [xf] = shooting_newtonNd(fhand,x0,T)

tolf = 1e-10;         % function convergence tolerance
tolx = 1e-8;          % step convergence tolerance
maxIters = 500;       % max # of iterations
x00 = x0;             % initial guess
delta = 0.1;
epsilon = 1e-3;

% Newton loop
for iter = 1:maxIters
    f = f_shooting(fhand,x0,T) - x0;               % evaluate function
    [dx, ~] = mfgcr_shooting(fhand, x0, -f, delta, epsilon, maxIters,T); % solve linear system
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

end
