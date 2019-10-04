function u = eval_u_step(t, x0, v0)

% Generating input
if t < 0
   u = 0;
else 
   u = [x0 + v0 * t, v0];
   %u = [10, 0];
end

