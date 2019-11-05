function f = eval_f_SquareDiagonal(x,p,u)
% example of function that evaluates the vector field f( ) at state x, with inputs u.
% p is a structure containing all model parameters
% in particular p.A and p.B and p.d
% corresponding to state space model dx/dt = p.A x+ p.sqd(x) + p.B u
% where the i-th component of sqd(x) is just sqd_i * (x[i])^2
%
% f=eval_f_SquareDiagonal(x,p,u);


f = (p.A * x) + (p.sqd .* x.*x) + (p.B * u);
