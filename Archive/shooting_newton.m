function [xf] = shooting_newton(x0,T,p,timestep)

tolf = 1e-10;         % function convergence tolerance
tolx = 1e-8;          % step convergence tolerance
maxIters = 500;       % max # of iterations
x00 = x0;             % initial guess
epsilon = 1e-3;
n = ceil(T/timestep);

% Newton loop
for iter = 1:maxIters
    f = ForwardEuler('human_car_behaviour_v5',x0,p,'sinusoidal_input',0,T,timestep,false);
    f = f(2,n) - x0(2);
    phi1 = ForwardEuler('human_car_behaviour_v5',x0 + epsilon*[1;0],p,'sinusoidal_input',0,T,timestep,false);
    phi2 = ForwardEuler('human_car_behaviour_v5',x0,p,'sinusoidal_input',0,T,timestep,false);
    phi1 = phi1(2,n);
    phi2 = phi2(2,n);
       
    dPhi_dx = (phi1 - phi2)/epsilon;
    J = dPhi_dx - 1;
    dx = -J\f;
    
    nf(iter) = abs(f);      % norm of f at step k+1
    ndx(iter) = abs(dx);    % norm of dx at step k+1
    x(:,iter) = x0 + dx;         % solution x at step k+1
    x0 = x(:,iter);              % set value for next guess
    if nf(iter) < tolf && ndx(iter) < tolx % check for convergence
        fprintf('Converged in %d iterations\n',iter);
        break
    end
end
xf = x(:,iter);