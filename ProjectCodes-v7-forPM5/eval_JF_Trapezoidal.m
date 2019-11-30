function JF_Trapezoidal = eval_JF_Trapezoidal(x_next,p,u_next)
% evaluates the Jacobian matrix required by Trapezoidal
% i.e. JF_Trapezoidal = 
% the name of the file containing function f( ) is passed in p.eval_f
%
% JF_Trapezoidal = eval_JF_Trapezoidal(x_next,p,u_next)

% copyright Luca Daniel, MIT 2018

N = length(x_next);
JF_Trapezoidal = eye(N) - 0.5* p.dt * feval(p.eval_Jf, x_next, p, u_next);
