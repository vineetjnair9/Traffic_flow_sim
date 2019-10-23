clear all
close all
format compact

% Example with two state linear system plus squared diagonal nonlinearity
[p,x,t_start] = getParam_SquaredDiagonalExample;
eval_f = 'eval_f_SquaredDiagonalExample';
eval_Jf = 'eval_Jf_SquaredDiagonalExample';

% Heat Conducting Bar Example
%[p,x,t_start] = getParam_HeatBarExample(10);
%eval_f = 'eval_f_LinearSystem';
%eval_Jf = 'eval_Jf_LinearSystem';


%%select input evaluation functions
eval_u = 'eval_u_step';
%eval_u = 'something else...';
u = feval(eval_u, t_start);



% test Analitycal Jacobian function vs general Finite Difference Jacobian
Jf_Analytical = feval(eval_Jf,x,p,u)

%some random experiments for dx
%dx = max(eps*1000,min(abs(x0))/100);
p.dxFD=1e-7;
Jf_FiniteDifference = eval_Jf_FiniteDifference(eval_f,x,p,u)
difference_J_an_FD=max(max(abs(Jf_Analytical-Jf_FiniteDifference)))


figure(1)
% or make a plot to study error on Finite Difference Jacobian for different dx
k=1;
for n=.01:.01:17,
   dx(k)=10^-(n);
   p.dxFD=dx(k);
   Jf_FiniteDifference = eval_Jf_FiniteDifference(eval_f,x,p,u);
   error(k)=max(max(abs(Jf_Analytical-Jf_FiniteDifference)));
   k=k+1;
end
loglog(dx,error)