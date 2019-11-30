function JF_BackwardEuler = eval_JF_BackwardEuler(x_next,p,u_next)
% evaluates the Jacobian matrix required by Backward Euler
% i.e. JF_BackwardEuler = Identity  - p.dt * Jf(x_next,p,p.u_next)
% the name of the file containing function f( ) is passed in p.eval_f
%
% JF_BackwardEuler = eval_JF_BackwardEuler(x_next,p,u_next)

% copyright Luca Daniel, MIT 2018

N = length(x_next);
JF_BackwardEuler = eye(N) - p.dt * feval(p.eval_Jf, x_next, p, u_next);
