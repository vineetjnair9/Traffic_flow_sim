function X = trap(fhand,x_start,p,t_start,t_stop,timestep)
% uses Trapezoidal rule to simulate model dx/dt=f(x)

X(:,1) = x_start;
t(1) = t_start;

for n=1:ceil((t_stop-t_start)/timestep) % time index
   
   dt = min(timestep, (t_stop-t(n)));
   t(n+1)= t(n) + dt;
   
   f = fhand(X(:,n),t(n));
   gamma = X(:,n) + (dt/2)*f;
      
   f_new = @(x,t) f_trap(dt,gamma,fhand,x,t);
   [X(:,n+1), ~] = newtonNdGMRES(f_new,X(:,n),p,t(n+1));
   
   disp(X(:,n+1));
   
   % Dynamic time stepping
   if norm(X(:,n+1)-X(:, n), inf)/ dt > 10000 || (convergence == 0)
       timestep = timestep/2;
   else 
       timestep = timestep*2;
   end
   
end

end
