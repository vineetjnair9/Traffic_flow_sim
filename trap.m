function X = trap(fhand,x_start,p,t_start,t_stop,timestep,u)
% uses Trapezoidal rule to simulate model dx/dt=f(x)
% u - input function handle 

X(:,1) = x_start;
t(1) = t_start;

%for n=1:ceil((t_stop-t_start)/timestep) % time index
for n=1:ceil((t_stop-t_start)/timestep) % time index
   dt = min(timestep, (t_stop-t(n)));
   t(n+1)= t(n) + dt;
   
   f = fhand(X(:,n),u(t(n)),t(n));
   gamma = X(:,n) + (dt/2)*f;
      
   f_new = @(x,u,t) f_trap(dt,gamma,fhand,x,u,t);
   [X(:,n+1), ~] = newtonNdGMRES(f_new,X(:,n),p,u,dt,t(n+1));
end

end
