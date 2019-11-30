function F_BackwardEuler = eval_F_BackwardEuler(x_next,p,u_next)
% evaluates the value of the function that Backward Euler needs to set to zero
% i.e. F_BackwardEuler = x_next - p.x_prev - p.dt * f(x_next,p,p.u_next)
% the name of the file containing function f( ) is passed in p.eval_f
%
% F_BackwardEuler = eval_F_BackwardEuler(x_next,p,u_next)

% copyright Luca Daniel, MIT 2018



F_BackwardEuler = x_next - p.x_prev - p.dt * feval(p.eval_f, x_next, p, u_next);
