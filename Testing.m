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

%--------------------------------
%    Initiate state variables  
%--------------------------------

% For 3 cars
x_0 = [16,8,0,10,5,0]; % [x - positions, v - speeds]

%--------------------------------
%    Forward Euler debugging  
%--------------------------------
t_start = 0; 
t_stop = 100; 
timestep = 0.1;
iterations = (t_stop/timestep) + 1;
X = ForwardEuler('human_car_behaviour',x_0,p,'human_car_input',t_start,t_stop,timestep,false);

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

A = jacobian_finite_difference('human_car_behaviour',x_0, p, 'human_car_input', 100, 0.001);