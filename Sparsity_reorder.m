%--------------------------------
%    Initiate system parameters 
%--------------------------------

p.l = 5; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars (m) 
p.T = 1.5; % Safe time headway 
p.a = 0.73; % Maximum allowed acceleration 
p.b = 1.67; % Comfortable deceleration 
p.v_eq = 30; % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent

% What are our input(s)?

%--------------------------------
%    Initiate state variables  
%--------------------------------

% x = [x_1; x_2;....;x_n; v_1; v_2;...; v_n]
num_cars = 10;
x_0 = zeros(1,2*num_cars);

x_0(1) = 1000*num_cars; % Starting position of lead car (m)
x_0(2) = 20; % Starting speed of lead cars (m/s) 

for i = 3:2*num_cars
    if (mod(i,2) == 0) % even
        % Assume speeds of remaining cars randomly initialized between 10
        % and 20 m/s (according to uniform distribution)
        x_0(i) = 10 + (30-10).*rand(1); % (m/s)
    else
        x_0(i) = x_0(1) - (i-2)*10; % Assume all cars start out evenly spaced by 10 m
    end
end

%--------------------------------
%    Forward Euler debugging  
%--------------------------------
t_start = 0; 
t_stop = 100; 
timestep = 0.1;
iterations = (t_stop/timestep) + 1;
X = ForwardEuler('human_car_behaviour',x_0,p,'human_car_input',t_start,t_stop,timestep,false);