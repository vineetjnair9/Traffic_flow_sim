function F_Trapezoidal = eval_F_Trapezoidal(x_next,p,u_next)
% evaluates the value of the function that Trapezoidal needs to set to zero
% i.e. F_Trapezoidal=x_next-p.x_prev-0.5*p.dt*[feval(p.eval_f,p.x_next,p,u_prev)+feval(p.eval_f,x_next,p,u_next)];
% the name of the file containing function f( ) is passed in p.eval_f
%
% F_Trapezoidal = eval_F_Trapezoidal(x_next,p)

% copyright Luca Daniel, MIT 2018



F_Trapezoidal = x_next - p.x_prev - 0.5 * p.dt * [feval(p.eval_f, p.x_prev, p, p.u_prev) + feval(p.eval_f, x_next, p, u_next)];
