function u = sinusoidal_input(t)

delta_t = 0.001; % (s) - has to match timestep used for FD integration

% Generating input

% Time period of sinusoidal input
T = 5; % (s)

% For 3 car case, lead car starting at 20 m ahead
u(1) = 20 + (5*T)/(2*pi) + 25*t - 5*cos((2*pi*t)/T);
u(2) = 25 + 5*sin((2*pi*t)/T);

end
