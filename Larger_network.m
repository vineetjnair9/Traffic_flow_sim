%--------------------------------
%    Initiate system parameters 
%--------------------------------

% Updated some parameters using enhanced IDM paper
p.l = 4; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars = desired stopping/jam distance (m) 
p.T = 1.5; % Safe time headway/gap (s)
p.a = 1.4 ; % Maximum allowed acceleration (m/s^2) - 0.73
p.b = 2 ; % Comfortable deceleration (m/s^2) - 1.67
p.v_eq = 120*(5/18); % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent 

%% Extending to larger no. of cars

num_cars = 30;
x_0 = zeros(1,2*num_cars); % Initial state (speeds & positions)

for j = 1:num_cars
    x_0 = zeros(1,2*num_cars);

    x_0(1) = 1000*num_cars; % Starting position of lead car (m)
    x_0(num_cars + 1) = 20; % Starting speed of lead car (m/s) 

    for i = 2:num_cars
        x_0(i) = x_0(1) - (i-1)*8; % Assume all cars start out evenly spaced by 8 m
    end

    for i = num_cars+2 : 2*num_cars
        % Assume speeds of remaining cars randomly initialized between 10 and 20 m/s (according to uniform distribution)
        x_0(i) = 10 + (20-10)*rand(1);
    end
    
    t_start = 0; 
    t_stop = 10; 
    timestep = 0.001;
    
end

X = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_input',t_start,t_stop,timestep,false);
A = jacobian_finite_difference('human_car_behaviour_v5',x_0,p,'constant_input',t_start,t_stop,timestep,false);

%%
hold on
figure(1)  
for i = 1:num_cars
    plot(t,X(i,:));
end
xlabel('Time [s]');
ylabel('Position along road [m]');
hold off

hold on
figure(2)  
for i = num_cars+1:2*num_cars
    plot(t,X(i,:));
end
xlabel('Time [s]');
ylabel('Speed of car [m/s]');