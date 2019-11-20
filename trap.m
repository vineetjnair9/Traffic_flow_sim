function X = trap(fhand,x_start,t_start,t_stop,timestep)
% uses Trapezoidal rule to simulate model dx/dt=f(x)

X(:,1) = x_start;
t(1) = t_start;

delta = 0.1;
epsilon = 1e-3;

for n=1:ceil((t_stop-t_start)/timestep) % time index
   
   dt = min(timestep, (t_stop-t(n)));
   t(n+1)= t(n) + dt;
   
   f = fhand(X(:,n),t(n));
   gamma = X(:,n) + (dt/2)*f;
      
   f_new = @(x,t) f_trap(dt,gamma,fhand,x,t);
   [X(:,n+1), ~] = newtonNdGCR(f_new,X(:,n),t(n+1),delta,epsilon);
   
end

end
