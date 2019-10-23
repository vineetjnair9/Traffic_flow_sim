function u = eval_u_step(t)

lead_x0 = 20; % Initial lead car position (m)
lead_v0 = 25; % Constant speed of lead car

% Generating input
if t < 0
   u = 0;
else 
   u(1) = lead_x0 + lead_v0 * t;
   u(2) = lead_v0;
end

