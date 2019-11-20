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
x_0 = [20,7,0,4,10,0]; % [x - positions, v - speeds]



t_start = 0; 
t_stop = 60; 
timestep = 0.00001;

% compare the values at discrete time points
no_testpts = int8((t_stop-t_start));
time_testpts = linspace(t_start, t_stop, no_testpts + 1);
%%
reference_timestep = 0.0001;
reference_X = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);
reference_t = t_start:reference_timestep:t_stop; 
% figure(1)
% hold on
% plot(reference_t,reference_X(1,:))
% plot(reference_t,reference_X(2,:))
% plot(reference_t,reference_X(3,:))
% legend('Car 1', 'Car 2', 'Car 3');
% xlabel('Time [s]');
% ylabel('Position along road [m]');
% 
% figure(2)
% hold on
% plot(reference_t,reference_X(4,:))
% plot(reference_t,reference_X(5,:))
% plot(reference_t,reference_X(6,:))
% legend('Car 1', 'Car 2', 'Car 3');
% xlabel('Time [s]');
% ylabel('Speed of car [m/s]');

%%
large_timestep = 0.01;  %timesteps below 0.001 gives errors in distance less than 100. 
large_X = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,large_timestep,false);

large_t = t_start:large_timestep:t_stop; 
% figure(1)
% hold on
% plot(large_t,large_X(1,:))
% plot(large_t,large_X(2,:))
% plot(large_t,large_X(3,:))
% legend('Car 1', 'Car 2', 'Car 3');
% xlabel('Time [s]');
% ylabel('Position along road [m]');
% 
% figure(2)
% hold on
% plot(large_t,large_X(4,:))
% plot(large_t,large_X(5,:))
% plot(large_t,large_X(6,:))
% legend('Car 1', 'Car 2', 'Car 3');
% xlabel('Time [s]');
% ylabel('Speed of car [m/s]');

%%
u1 = constant_speed_input(1);


[de, se] = FindError(reference_X, large_X, reference_t, large_t, time_testpts);
% phi_TR = traprule_nonlinear(phi_0, large_timestep, t_start, t_stop, @(phi,t)human_car_behaviour_v6(phi,p, u, t));




%%
t_start = 0; 
t_stop = 1; 
timestep = 0.01;
%X = ForwardEuler('human_car_behaviour_v5',x_0,p,'sinusoidal_input',t_start,t_stop,timestep,false);

u = @(t) constant_speed_input(t);
fhand = @(x,t) human_car_behaviour_v5(x,p,u,t);
X = Copy_of_trap(fhand,x_0,p, t_start,t_stop,timestep);

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









