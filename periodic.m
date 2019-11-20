%% Testing periodic input
t_start = 0; 
t_stop = 20; 
timestep = 0.001;
iterations = (t_stop/timestep) + 1;

u = zeros(iterations,2);

t = t_start:timestep:t_stop; 
t = t';
for i = 1:length(u)
    ans = sinusoidal_input(t(i));
    u(i,1) = ans(1);
    u(i,2) = ans(2);
end

hold on
plot(t,u(:,1));
plot(t,u(:,2));
legend('Lead car position','Lead car speed');

%% Periodic steady state
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
p.dxFD = 0.001;

% For 3 cars (excluding lead car)
x_0 = [12,5,0,10,5,0]; % [x - positions, v - speeds]

%%
t_start = 0; 
t_stop = 10; 
timestep = 0.1;
%X = ForwardEuler('human_car_behaviour_v5',x_0,p,'sinusoidal_input',t_start,t_stop,timestep,false);

u = @(t) constant_speed_input(t);
fhand = @(x,t) human_car_behaviour_v5(x,p,u,t);
X = trap(fhand,x_0,p,t_start,t_stop,timestep);

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

%% Shooting Newton
% Using trap
% T = 10;
% u = @(t) sinusoidal_input(t);
% fhand = @(x,t) human_car_behaviour_v5(x,p,u,t);
% xf = shooting_newtonNd(fhand,x_0,T);

% Using Forward Euler
T = 0.1;
timestep = 0.001;
x_0 = [0,5]'; % [x - positions, v - speeds]
fhand = @(x_0) shooting_newton_v2(x_0,T,p,timestep);
xf = newtonNd(fhand,x_0);
