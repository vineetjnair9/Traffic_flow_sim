function [X,t] = BE_adaptive(fhand,x_start,p,t_start,t_stop,timestep,u)
% uses Trapezoidal rule to simulate model dx/dt=f(x)
% u - input function handle 

X(:,1) = x_start;
t(1) = t_start;

min_slope = 0.1;
max_slope = 40;
num_cars = 25;

n = 1;
while t(n) < t_stop % time index
   dt = min(timestep, (t_stop-t(n)));
   t(n+1)= t(n) + dt;
   
   x0 = X(:,n);
   gamma = x0;
      
   f_new = @(x,u,t) f_trap(dt,gamma,fhand,x,u,t);
   [X(:,n+1), converged, ~] = newtonNdGMRES_be(f_new,X(:,n),p,u,dt,t(n+1));
   
   % Dynamic adaptive time stepping
   
   % Check slope condition only using velocity states
   slope = norm(X(num_cars+1:end,n+1)-X(num_cars+1:end,n), Inf)/dt;
   if (converged == 0) || slope > max_slope % Max slope (lead car's constant speed)
       timestep = timestep/2;
       n = n-1;
   elseif (slope < min_slope) % min slope
       timestep = timestep*2;
       n = n-1;
       min_slope = min_slope * 0.1;
   end
   n = n+1;
   
end

end
