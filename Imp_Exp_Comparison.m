%% Implicit explicit methods compared

p.l = 5; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars = desired stopping/jam distance (m) 
p.T = 1.6; % Safe time headway/gap (s) - 1.5
p.a = 0.73; % Maximum allowed acceleration (m/s^2) - 1.4
p.b = 1.67; % Comfortable deceleration (m/s^2) - 2
p.v_eq = 100*(5/18); % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent 
p.dxFD=1e-7; % For finite difference Jacobian

%% Runtime and accuracy comparisons
num_cars = 25;

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

t_start = 0; 
t_stop = 120; % 

%% 'True' solution (FE using very small timestep)
timestep = 1e-4;
tic
X_true = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);
FE_time_true = toc

%%
timestep = 0.1;
tic
X_FE = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);
FE_time = toc

%%
u = @constant_speed_input;
fhand = @(x,u,t) human_car_behaviour_v5(x,p,u,t);

%%
timestep = 1e-3;
tic
X_trap = trap(fhand,x_0,p,t_start,t_stop,timestep,u);
trap_time = toc

%%
timestep = 0.1;
tic
[X_trap_adaptive,t_trap_adapt] = trap_adaptive(fhand,x_0,p,t_start,t_stop,timestep,u);
trap_adapt_time = toc

%%
tic 
X_be = BE(fhand,x_0,p,t_start,t_stop,timestep,u);
be_time = toc

%%
tic 
[X_be_adaptive, t_be_adapt] = BE_adaptive(fhand,x_0,p,t_start,t_stop,timestep,u);
be_time = toc

%% Accuracy

timestep = 1e-3;
t_comp = 0:timestep:t_stop;
%t_comp = t_trap_adapt;

X_comp = X_be;

t_true = 0:1e-4:t_stop;

rel_error = zeros(size(X_comp,2),1);
for i = 2:size(X_comp,2)
    [closest_time, index] = min(abs(t_true - t_comp(i)));
    %index = 1+floor(t_comp(i)/1e-4);
    %index = find(t_true == t_comp(i));
    rel_error(i) = (norm(X_comp(:,i) - X_true(:,index))/norm(X_true(:,index)))*100;
end

% Average relative error for whole simulation time
rel_error_avg = mean(rel_error)

%% Plots

X = X_FE;
t = t_start:timestep:t_stop; 

% X = X_trap_adaptive;
% t = t_trap_adapt; 

figure(1)  
hold on
for i = 1:num_cars
    plot(t,X(i,:));
end
% for i = 1:num_cars
%     plot(t_true,X_true(i,:));
% end
xlabel('Time [s]');
ylabel('Position along road [m]');
%legend('Estimate','True');
hold off

figure(2)  
hold on
for i = num_cars+1:2*num_cars
    plot(t,X(i,:));
end
% for i = num_cars+1:2*num_cars
%     plot(t_true,X_true(i,:));
% end
xlabel('Time [s]');
ylabel('Speed of car [m/s]');
%legend('Estimate','True');
hold off
