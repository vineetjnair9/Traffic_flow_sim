%--------------------------------
%    Initiate system parameters 
%--------------------------------

p.l = 5; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars = desired stopping/jam distance (m) 
p.T = 1.6; % Safe time headway/gap (s) - 1.5
p.a = 0.73; % Maximum allowed acceleration (m/s^2) - 1.4
p.b = 1.67; % Comfortable deceleration (m/s^2) - 2
p.v_eq = 100*(5/18); % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent 
p.dxFD=1e-7; % For finite difference Jacobian

%% Extending to larger no. of cars

num_cars = 30;
x_0 = zeros(1,2*num_cars); % Initial state (speeds & positions)

for j = 1:num_cars
    x_0 = zeros(1,2*num_cars);

    for i = 1:num_cars
        % Assume all cars start out evenly spaced by 20 m
        x_0(num_cars + 1 - i) = 50 + (num_cars - i)*20; 
    end

    for i = num_cars : 2*num_cars
        % Assume speeds of all cars randomly initialized between 20 and 30 m/s (according to uniform distribution)
        x_0(i) = 20 + (30-20)*rand(1);
    end
       
end
x_0 = x_0';

t_start = 0; 
t_stop = 10; 
timestep = 0.0001;
X = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);
%A = jacobian_finite_difference('human_car_behaviour_v5',x_0,p,'constant_speed_input',10,0.001);

%%
A_reordered = A;
A_reordered(1:num_cars,:) = A(num_cars+1:end,:);
A_reordered(num_cars+1:end,:) = A(1:num_cars,:);

%%

t = t_start:timestep:t_stop; 

figure(1)  
hold on
for i = 1:num_cars
    plot(t,X(i,:));
end
xlabel('Time [s]');
ylabel('Position along road [m]');
hold off

figure(2)  
hold on
for i = num_cars+1:2*num_cars
    plot(t,X(i,:));
end
xlabel('Time [s]');
ylabel('Speed of car [m/s]');
hold off

%% 
spy(A)
cond(A)

%% Model Order Reduction from 30 to 5 cars
A = jacobian_finite_difference('human_car_behaviour_v5',x_0, p, 'constant_speed_input', 10, 0.001);
B = U_jacobian_finite_difference('human_car_behaviour_v5',x_0, p, 'constant_speed_input', 10, 0.001);
Bnew = [human_car_behaviour_v5(x_0,p,constant_speed_input(10),10) B];
    
[A_, b_, c_, sys] = eigTrunc(A, Bnew, ones(60,1), 10);



