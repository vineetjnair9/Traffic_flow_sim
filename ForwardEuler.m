function X = ForwardEuler(eval_f,x_start,p,eval_u,t_start,t_stop,timestep,visualize)

X(:,1) = x_start; % State variables at each time step
t(1) = t_start;
if visualize
   visualizeResults(t,X,1,'.b');
end
for n=1:ceil((t_stop-t_start)/timestep)
   dt = min(timestep, (t_stop-t(n)));
   t(n+1) = t(n) + dt;
   u = feval(eval_u, t(n));
   f = feval(eval_f, X(:,n), p, u);
   X(:,n+1)= X(:,n) +  dt * f;
   if visualize
      visualizeResults(t,X,n+1,'.b');
   end
end
