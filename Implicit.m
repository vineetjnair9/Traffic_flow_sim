function [X,k] = ImplicitMethod(method,eval_f,x_start,p,eval_u,t_start,t_stop,timestep,visualize,FiniteDifference,eval_Jf)
% uses an Implicit ODE integration method 
% to simulate states model dx/dt=f(x,p,u)
% from state x_start at time t_start
% until time t_stop, with time intervals timestep
% eval_f is a string containing the name of the function that evaluates f(x,p,u)
% eval_u is a string containing the name of the funciton that evaluates u(t)
% It uses separatly defined functions val_F_BackwardEuler, eval_F_trapezoidal
% [and corresponding Jacobians eval_JF_BackwardEuler, eval_JF_trapezoidal]
% to define the implicit method (e.g. Backward Euler or Trapezoidal etc.)
% possible values for method are: 'BackwardEuler' and 'Trapezoidal'
%
% X = ImplicitMethod(eval_f,x_start,p,eval_u,t_start,t_stop,timestep,visualize,FiniteDifference,eval_Jf)


% copyright Luca Daniel, MIT 2018

%errF_implicit=1e-3;
%errDeltax=1e-3;
%relDeltax=0.01;
%MaxIter=10;

errF_implicit=1e-8;
errDeltax=1e-8;
relDeltax=1e-8;
MaxIter=5;

p.eval_f = eval_f;
if ~FiniteDifference
   p.eval_Jf = eval_Jf;
end

eval_F_implicit = ['eval_F_' method];
eval_JF_implicit = ['eval_JF_' method];


X(:,1) = x_start;
t(1) = t_start;
if visualize
   visualizeResults(t,X,1,'.r');
end
n=1;
while n <= ceil((t_stop-t_start)/timestep),
   p.x_prev = X(:,n);
   p.u_prev = feval(eval_u, t(n)); 
   p.dt = min(timestep, (t_stop-t(n)));
   t(n+1)= t(n) + p.dt;
   u_next = feval(eval_u, t(n+1));   
   x0=X(:,n); %this is the easiest guess but could also use one step of Forward Euler
   %xFE=ForwardEuler(eval_f,X(:,n),p,eval_u,t(n),t(n+3),p.dt,0);    
   %x0=xFE(:,2);  %one step of FE
   [X(:,n+1),converged,errF_k,errDeltax_k,relDeltax_k,k(n)] = NewtonMethod(eval_F_implicit,x0,p,u_next,errF_implicit,errDeltax,relDeltax,MaxIter,0,FiniteDifference,eval_JF_implicit);
   if ~converged
      timestep=timestep/2;
      disp(['at t=' num2str(t(n+1)) ' Newton did not converge: decreasing stepsize to ' num2str(timestep)])
      n=n-1;
   elseif visualize
      visualizeResults(t,X,n+1,'.r');
      %figure(13)
      %plot(n,k(n),'.'); hold on
   end
   n=n+1;
end


