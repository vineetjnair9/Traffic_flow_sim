%% Iterative solvers
% Using GMRES or BiCG to solve the linearized system iteratively
% i.e. A*x = xdot

p.l = 4; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars = desired stopping/jam distance (m) 
p.T = 1.5; % Safe time headway/gap (s)
p.a = 1.4 ; % Maximum allowed acceleration (m/s^2) - 0.73
p.b = 2 ; % Comfortable deceleration (m/s^2) - 1.67
p.v_eq = 120*(5/18); % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent 

% Initialize states for 3 cars (excluding lead car)
x_0 = [12,5,0,10,5,0]; % [x - positions, v - speeds]

A = jacobian_finite_difference('human_car_behaviour_v5',x_0, p, 'constant_input', 10, 0.001);

% Steady state analysis
%xdot = zeros(size(A,1),1);

% Other examples
xdot = [25; 20; 15; 1; 1.5; 0.5];

x = gmres(A,xdot)

%% Preconditioners


%% Multiple sources/loads/excitations


%% Parameter sensitivity


