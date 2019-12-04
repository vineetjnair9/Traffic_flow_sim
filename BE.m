function X = BE(fhand,x_start,p,t_start,t_stop,timestep,u)
% uses Trapezoidal rule to simulate model dx/dt=f(x)
% u - input function handle 

X(:,1) = x_start;
t(1) = t_start;

for n=1:ceil((t_stop-t_start)/timestep) % time index
   dt = min(timestep, (t_stop-t(n)));
   t(n+1)= t(n) + dt;
   
   x0 = X(:,n);
   gamma = x0;
      
   f_new = @(x,u,t) f_be(dt,gamma,fhand,x,u,t);
   [X(:,n+1), ~] = newtonNdGMRES_be(f_new,x0,p,u,dt,t(n+1));
end

end