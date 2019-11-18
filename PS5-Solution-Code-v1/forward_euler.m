function phi = forward_euler(phi_0, delta_t, t_i, t_f, f)

% phi_0 = initial condition
% delta_t = time step
% t_i = initial time
% t_f = final time
% f = function that computes f for a given phi

N = length(phi_0);
L = (t_f-t_i)/delta_t;
phi = NaN(N,L+1);

t = t_i;
phi(:,1) = phi_0;

for i = 2:L+1
  t_old = t;
  phi_old = phi(:,i-1);
  t = t + delta_t;
  phi(:,i) = phi_old + delta_t*f(phi_old,t_old);
end

end
