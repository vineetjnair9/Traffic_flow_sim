function Jf = eval_Jf_linearSystem(x,p,u)
% evaluates the Jacobian of the vector field f( ) at state x, with inputs u.
% p is a structure containing all model parameters
% in particular p.A and p.B 
% corresponding to state space model dx/dt = p.A x + p. B u
%
% f=eval_Jf_linear(x,p,u)


Jf=p.A;
% notice this is very very simple because it is a linear function
% if your function is nonlinear you could just modify this fuction
% and make it as complicated as needed