function Jf = Jf_FiniteDifference(eval_f,x0,p,u)
% evaluates the Jacobian of the vector field f( ) at state x0
% p is a structure containing all model parameters
% u is the value of the imput at the curren time
% uses a finite difference approach 
% computes one column at the time as difference
% of function evaluations perturbed by scalar p.dxFD
%
% Jf = eval_Jf_FiniteDifference(eval_f,x0,p,u);

% copyright Luca Daniel, MIT 2018


N  = length(x0);
f_x0 = feval(eval_f,x0,p,u);

for k=1:N
   xk    = x0;
   xk(k) = x0(k) + p.dxFD; 
   f_xk = feval(eval_f,xk,p,u);
   Jf(:,k)= (f_xk - f_x0)/p.dxFD;
end



