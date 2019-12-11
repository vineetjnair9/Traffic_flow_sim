function u = constant_speed_input_opt(t, v0)

lead_x0 = 2050; % Initial lead car position (m) - set as 20 m in front of car indexed 1
lead_v0 = v0*(5/18); % Constant speed of lead car (m/s)

% Generating input
if t < 0
   u = 0;
else 
   u(1) = lead_x0 + lead_v0 * t;
   u(2) = lead_v0;
end
end
