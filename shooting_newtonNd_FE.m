function [xf] = shooting_newtonNd_FE(x0,T,params,timestep)

tolf = 1e-10;         % function convergence tolerance
tolx = 1e-8;          % step convergence tolerance
maxIters = 500;       % max # of iterations
x00 = x0;             % initial guess
delta = 0.1;
epsilon = 1e-3;
n = ceil(T/timestep);

% Newton loop
for iter = 1:maxIters
    f = ForwardEuler('human_car_behaviour_v5',x0,params,'sinusoidal_input',0,T,timestep,false);
    f = f(:,n) - x0;
    [dx, ~] = mfgcr_shooting_FE(x0, params, -f, delta, epsilon, maxIters,T); % solve linear system
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
