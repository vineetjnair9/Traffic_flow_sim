function f = eval_f_linearSystem(x,p,u)
% evaluates the vector field f( ) at state x, with inputs u.
% p is a structure containing all model parameters
% in particular p.A and p.B 
% corresponding to state space model dx/dt = p.A x + p.B u
%
% f = eval_f_linearSystem(x,p,u)



f=p.A * x + p.B * u;
