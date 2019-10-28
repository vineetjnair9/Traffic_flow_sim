function u = human_car_input(t)

delta_t = 0.01; % (s)

% Generating input

if (t <= 0) 
    u(1) = 20; % Initial position (m)
    u(2) = 120*(5/18); % Initial speed (m/s) 
    
else
    prev = human_car_input(t-delta_t);

    u(1) = prev(1) + prev(2)*delta_t;
    u(2) = prev(2) + sin(0.05*t);

end

end