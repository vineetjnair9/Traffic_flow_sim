%% Optimization

p.l = 5; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars = desired stopping/jam distance (m) 
p.T = 1.6; % Safe time headway/gap (s) - 1.5
p.a = 0.73; % Maximum allowed acceleration (m/s^2) - 1.4
p.b = 1.67; % Comfortable deceleration (m/s^2) - 2
p.v_eq = 120*(5/18); % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent 
p.dxFD = 1e-7; % For finite difference Jacobian
p.dt = 1e-2; % Forward Euler timestep for implicit Newton guess

road_section_length = 200;
road_sectionX = 0:road_section_length:6000; % for the others
t_start = 0;
t_stop = 180;
timestep = 0.1;
num_cars = 100;

%%
num_cars = 100; 

x_0 = zeros(2*num_cars,1); % Initial state (speeds & positions)

for i = 1:num_cars
    % Assume all cars start out evenly spaced by 10 m
    % Last follower car starts at 50 m
    x_0(i) = 50 + (num_cars-i)*20; 
end

for i = num_cars+1:2*num_cars
    % Assume speeds of all cars randomly initialized between 20 and 30 m/s (according to uniform distribution)
    x_0(i) = 20 + (30-20)*rand(1);
end

%% Variations in inputs
% Maximize mean flow
lead_speed = 20:5:140;
flow_cars = zeros(1,length(lead_speed));
for i = 1:length(lead_speed)
    v0 = lead_speed(i);
    u = @(t) constant_speed_input_opt(t,v0);
    X = ForwardEuler('human_car_behaviour_v5',x_0,p,u,t_start,t_stop,timestep,false);
    
    cars_on_road = howmanycars(X, num_cars, road_sectionX, t_stop/timestep, road_section_length)/road_section_length;
    veloc_on_road = velocityheatmap(X, num_cars, road_sectionX, t_stop/timestep, road_section_length);
    flow_cars(i) = mean(cars_on_road.*veloc_on_road);
end
plot(lead_speed,flow_cars)
xlabel('Lead car speed (km/h)');
ylabel('Spatially averaged flow at 180 s (cars/s)');

%% Minimize peak density
lead_speed = 20:5:140;
peak_density = zeros(1,length(lead_speed));
for i = 1:length(lead_speed)
    v0 = lead_speed(i);
    u = @(t) constant_speed_input_opt(t,v0);
    X = ForwardEuler('human_car_behaviour_v5',x_0,p,u,t_start,t_stop,timestep,false);
    cars_on_road = howmanycars(X, num_cars, road_sectionX, t_stop/timestep, road_section_length)/road_section_length;
    peak_density(i) = max(cars_on_road);
end
plot(lead_speed,peak_density)
xlabel('Lead car speed (km/h)');
ylabel('Peak density at 180 s (cars/m)');

%% Variations in speed limits
% Maximize mean flow
speed_limit = 80:5:160;
flow_cars = zeros(1,length(speed_limit));

for i = 1:length(speed_limit)  
    p.v_eq = speed_limit(i)*(5/18);
    X = ForwardEuler('human_car_behaviour_v5',x_0,p,u,t_start,t_stop,timestep,false);
    cars_on_road = howmanycars(X, num_cars, road_sectionX, t_stop/timestep, road_section_length)/road_section_length;
    veloc_on_road = velocityheatmap(X, num_cars, road_sectionX, t_stop/timestep, road_section_length);
    flow_cars(i) = mean(cars_on_road.*veloc_on_road);
end

plot(speed_limit,flow_cars);
xlabel('Speed limit (km/h)');
ylabel('Spatially averaged flow at 180 s (cars/s)');

%% Minimize peak density
speed_limit = 80:5:140;
peak_density = zeros(1,length(speed_limit));

for i = 1:length(speed_limit)  
    p.v_eq = speed_limit(i)*(5/18);
    X = ForwardEuler('human_car_behaviour_v5',x_0,p,u,t_start,t_stop,timestep,false);
    cars_on_road = howmanycars(X, num_cars, road_sectionX, t_stop/timestep, road_section_length)/road_section_length;
    peak_density(i) = max(cars_on_road);
end

plot(speed_limit,peak_density)
xlabel('Speed limit (km/h)');
ylabel('Peak density at 180 s (cars/m)');
    