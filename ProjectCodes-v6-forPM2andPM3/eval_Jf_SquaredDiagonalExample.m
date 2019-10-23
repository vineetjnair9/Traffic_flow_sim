function Jf = eval_Jf_SquaredDiagonal(x,p,u)
% example of function that evaluates the Jacobian
% of vector field f( ) at state x, with inputs u.
% p is a structure containing all model parameters
% in particular p.A and p.B and p.d
% in state space model dx/dt = p.A x + sqd(x)+ p.B u
% where the i-th component of sqd(x) is just sqd_i * (x[i])^2
%
% Jf=eval_Jf_SquaredDiagonal(x,p,u);

% copyright Luca Daniel, MIT 2018

Jf = p.A  + diag(2 * p.sqd .* x);
