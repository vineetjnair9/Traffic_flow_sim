function u = vary_input(t)

lead_x0 = 2050; % Initial lead car position (m) - set as 10-20 m in front of car indexed 1
lead_v0 = 80*(5/18); % Constant speed of lead car

% Generating input
if t < 0
   u = 0;
elseif t <= 60
   u(1) = lead_x0 + lead_v0 * t;
   u(2) = lead_v0;
else % Lead car crashes at 60 s
   u(1) = lead_x0 + 60 * lead_v0;
   u(2) = 0;
end
   
end

