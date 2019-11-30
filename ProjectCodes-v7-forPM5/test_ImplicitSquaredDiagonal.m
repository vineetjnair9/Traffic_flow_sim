clear all
close all

% Example with two state linear system plus squared diagonal nonlinearity
[p,x_start,t_start,t_stop,max_dt_FE] = getParam_SquaredDiagonalExample;
dt_implicit=10*max_dt_FE;
eval_f = 'eval_f_SquaredDiagonalExample';
eval_Jf = 'eval_Jf_SquaredDiagonalExample';
p.dxFD=1e-7;   %if using finite difference Jacobian

% Heat Conducting Bar Example
%[p,x_start,t_start,t_stop,max_dt_FE] = getParam_HeatBarExample(10);
%dt_implicit=10*max_dt_FE;
%eval_f = 'eval_f_LinearSystem';
%eval_Jf = 'eval_Jf_LinearSystem';
%p.dxFD=1e-7;   %if using finite difference Jacobian

%%select input evaluation functions
eval_u = 'eval_u_step';
%eval_u = 'something else...';




figure(2)
method = 'BackwardEuler';

% test Implicit Backward Euler using finite difference Jacobian
visualize = 0;
FiniteDifference = 1;
[X_BE_FD,k_FD] = Implicit(method,eval_f,x_start,p,eval_u,t_start,t_stop*0.99,dt_implicit,visualize,FiniteDifference);
%remove column to visualize # of iterations at each time step
number_of_iter_FD = k_FD; 

% test Implicit Backward Euler using eval_Jf
visualize = 1;
FiniteDifference = 0;
[X_BE_an,k_an] = Implicit(method,eval_f,x_start,p,eval_u,t_start,t_stop*0.99,dt_implicit,visualize,FiniteDifference,eval_Jf);
%remove column to visualize # of iterations at each time step
number_of_iter_an = k_an; 

difference_BE_J_an_FD=norm(X_BE_FD - X_BE_an)

% compare to Forward Euler
[X_FE] = ForwardEuler(eval_f,x_start,p,eval_u,t_start,t_stop*0.99,max_dt_FE,visualize);




figure(3)
method = 'Trapezoidal';

% test Implicit Backward Euler using finite difference Jacobian
visualize = 0;
FiniteDifference = 1;
[X_TR_FD,k_FD] = Implicit(method,eval_f,x_start,p,eval_u,t_start,t_stop*0.99,dt_implicit,visualize,FiniteDifference);
%remove column to visualize # of iterations at each time step
number_of_iter_FD = k_FD; 

% test Implicit Backward Euler using eval_Jf
visualize = 1;
FiniteDifference = 0;
[X_TR_an,k_an] = Implicit(method,eval_f,x_start,p,eval_u,t_start,t_stop*0.99,dt_implicit,visualize,FiniteDifference,eval_Jf);
%remove column to visualize # of iterations at each time step
number_of_iter_an = k_an; 

difference_TR_J_an_FD=norm(X_TR_FD - X_TR_an)

% compare to Forward Euler
[X_FE] = ForwardEuler(eval_f,x_start,p,eval_u,t_start,t_stop*0.99,max_dt_FE,visualize);


