function u = eval_u_step(t, lead_x0, lead_v0)

% Generating input
if t < 0
   u = 0;
else 
   u(1) = lead_x0 + lead_v0 * t;
   u(2) = lead_v0;
   %u = [10, 0];
end

