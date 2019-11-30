clear all
close all
format compact

% Example with two state linear system plus squared diagonal nonlinearity
[p,x0,t0] = getParam_SquaredDiagonalExample;
eval_f = 'eval_f_SquaredDiagonalExample';
eval_Jf = 'eval_Jf_SquaredDiagonalExample';
p.dxFD=1e-7;   %if using finite difference Jacobian

% Heat Conducting Bar Example
%[p,x0,t0] = getParam_HeatBarExample(10);
%eval_f = 'eval_f_LinearSystem';
%eval_Jf = 'eval_Jf_LinearSystem';
%p.dxFD=1e-7;   %if using finite difference Jacobian

%%select input evaluation functions
eval_u = 'eval_u_step';
%eval_u = 'something else...';
u = feval(eval_u, t0);



errF=1e-3;
errDeltax=1e-3;
relDeltax=0.01;
MaxIter=20;
visualize=1;
FiniteDifference=0;  %set this to use analytical Jacobian and provide eval_Jf function
%FiniteDifference=1;  %set this to use finite difference Jacobian
figure(1)
[x,converged,errF_k,errDeltax_k,relDeltax_k,iterations] = NewtonMethod(eval_f,x0,p,u,errF,errDeltax,relDeltax,MaxIter,visualize,FiniteDifference,eval_Jf)


