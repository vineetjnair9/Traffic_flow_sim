function u = constant_speed_input(t)

lead_x0 = 550; % Initial lead car position (m) - set as 20 m in front of car indexed 1
lead_v0 = 80*(5/18); % Constant speed of lead car

% Generating input
if t < 0
   u = 0;
else 
   u(1) = lead_x0 + lead_v0 * t;
   u(2) = lead_v0;
end
end

