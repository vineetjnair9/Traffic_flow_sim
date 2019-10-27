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

%--------------------------------
%    Initiate state variables  
%--------------------------------

% For 3 cars (excluding lead car)
x_0 = [12,5,0,10,5,0]; % [x - positions, v - speeds]

%--------------------------------
%    Forward Euler debugging  
%--------------------------------
t_start = 0; 
t_stop = 50; 
timestep = 0.01;
iterations = (t_stop/timestep) + 1;
X = ForwardEuler('human_car_behaviour_v5',x_0,p,'human_car_input',t_start,t_stop,timestep,false);

t = t_start:timestep:t_stop; 
figure(1)
hold on
plot(t,X(1,:))
plot(t,X(2,:))
plot(t,X(3,:))
legend('Car 1', 'Car 2', 'Car 3');
xlabel('Time [s]');
ylabel('Position along road [m]');

figure(2)
hold on
plot(t,X(4,:))
plot(t,X(5,:))
plot(t,X(6,:))
legend('Car 1', 'Car 2', 'Car 3');
xlabel('Time [s]');
ylabel('Speed of car [m/s]');

% Final gaps / bumper-to-bumper distance
Car1_gap = X(1,iterations) - X(2,iterations)
Car2_gap = X(2,iterations) - X(3,iterations)

%--------------------------------
%    Jacobian linearization   
%--------------------------------

A = jacobian_finite_difference('human_car_behaviour_v5',x_0, p, 'eval_u_step', 10, 0.001);
%% Reordering A to correspond to the state vector [v, x] instead
num_cars = 3;
A_reordered = A;
A_reordered(1:num_cars,:) = A(num_cars+1:end,:);
A_reordered(num_cars+1:end,:) = A(1:num_cars,:);

%% Extending to larger no. of cars

num_cars = 30;

for j = 1:length(num_cars) 
    x_0 = zeros(1,2*num_cars(j));

    x_0(1) = 1000*num_cars(j); % Starting position of lead car (m)
    x_0(num_cars(j)+1) = 20; % Starting speed of lead car (m/s) 

    for i = 2:num_cars(j)
        x_0(i) = x_0(1) - (i-1)*8; % Assume all cars start out evenly spaced by 8 m
    end

    for i = num_cars(j)+2:2*num_cars(j)
        % Assume speeds of remaining cars randomly initialized between 10 and 20 m/s (according to uniform distribution)
        x_0(i) = 10 + (20-10)*rand(1);
    end
end
