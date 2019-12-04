function u = vary_input(t)

lead_x0 = 150; % Initial lead car position (m) - set as 10-20 m in front of car indexed 1
lead_v0 = 120*(5/18); % Constant speed of lead car

% Generating input
if t < 0
   u = 0;
elseif t < 60
   v = lead_v0;
else % Lead car crashes at 60 s
   v = 0;
end
   u(1) = lead_x0 + v * t;
   u(2) = v;
end

