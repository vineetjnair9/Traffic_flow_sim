function u = constant_speed_input(t)

lead_x0 = 20; % Initial lead car position (m)
lead_v0 = 120*(5/18); % Constant speed of lead car

% Generating input
if t < 0
   u = 0;
else 
   u(1) = lead_x0 + lead_v0 * t;
   u(2) = lead_v0;
end
end

