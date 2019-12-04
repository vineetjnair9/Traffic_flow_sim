%--------------------------------
%    Initiate system parameters 
%--------------------------------

% Updated some parameters using enhanced IDM paper
p.l = 5; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars = desired stopping/jam distance (m) 
p.T = 1.6; % Safe time headway/gap (s) - 1.5
p.a = 0.73; % Maximum allowed acceleration (m/s^2) - 1.4
p.b = 1.67; % Comfortable deceleration (m/s^2) - 2
p.v_eq = 100*(5/18); % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent 
p.dxFD=1e-7; % For finite difference Jacobian

%%
%--------------------------------
%    Initiate state variables  
%--------------------------------

% For 3 cars (excluding lead car)
x_0 = [12,6,0,10,4,0]; % [x - positions, v - speeds]

%--------------------------------
%    Forward Euler debugging  
%--------------------------------
t_start = 0; 
t_stop = 100; 
timestep = 0.01;
iterations = (t_stop/timestep) + 1;
X = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);

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

%% Newton method with continuation scheme 
% Cconvergence checks.
errf=1e-3;
errDeltax=1e-3;
relDeltax=0.01;
MaxIter=20;
visualize=0;
FiniteDifference = 1;
x0 = x_0;
p.dxFD=1e-7;             % or can use finite difference jacobian with this perturbation

% eval_Jf = 'eval_Jf_FiniteDifference';
eval_Jf = 'jacobian_finite_difference';
% [q, xs] = continuation_p1b('human_car_behaviour_v5', 'curlyf',x0, p, 'constant_input', errf, errDeltax, relDeltax, MaxIter, visualize, FiniteDifference,eval_Jf)
% [q, xs] = continuation_p1b('human_car_behaviour_v5', x0, p, 'constant_input')

% [x_analytic,converged,errf_k,errDeltax_k,relDeltax_k,iterations] = NewtonMethod('human_car_behaviour_v5', x0, p, 'constant_input', errf,errDeltax,relDeltax,MaxIter,visualize,FiniteDifference,eval_Jf )
% x_0 = [12,5,0,10,5,0]; % [x - positions, v - speeds]

x0 = [70, 50, 10, 3 , 4, 2];
% [x_analytic,converged,errf_k,errDeltax_k,relDeltax_k,iterations] = NewtonMethod('human_car_behaviour_v5', x0, p, 'constant_input', errf,errDeltax,relDeltax,MaxIter,visualize,FiniteDifference,eval_Jf )

%% Reordering A to correspond to the state vector [v, x] instead
num_cars = 3;
A_reordered = A;
A_reordered(1:num_cars,:) = A(num_cars+1:end,:);
A_reordered(num_cars+1:end,:) = A(1:num_cars,:);

%--------------------------------
%    Jacobian linearization   
%--------------------------------
%% Model Order Reduction
x_0 = [12,5,0,10,5,0];
u = constant_speed_input(5);
J = Jf_FiniteDifference('human_car_behaviour_v5',x_0, p,u);
%A = jacobian_finite_difference('human_car_behaviour_v5',x_0, p, 'constant_speed_input', 10, 0.001);
%%
B = U_jacobian_finite_difference('human_car_behaviour_v5',x_0, p, 'constant_speed_input', 10, 0.001);
Bnew = [human_car_behaviour_v5(x_0,p,constant_speed_input(10),10) B];
    
[A_, b_, c_, sys] = eigTrunc(A, Bnew, ones(6,1), 1);

%% Implicit explicit methods compared

x_0 = [12,6,0,10,4,0]; % [x - positions, v - speeds]
% Need to change lead car position too in input when we change no. of cars!

%% Runtime and accuracy comparisons
timestep = 1e-4;
num_cars = 3;

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
t_stop = 50; 

%% 'True' solution (FE using very small timestep)

timestep = 1e-5;
tic
X_true_3 = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);
FE_time_true = toc;

%%
timestep = 1e-4;

u = @constant_speed_input;
fhand = @(x,u,t) human_car_behaviour_v5(x,p,u,t);

tic
[X_trap_adaptive,t_adapt] = trap_adaptive(fhand,x_0,p,t_start,t_stop,timestep,u);
trap_adapt_time = toc
%trap_adapt_accuracy = (norm(X_trap_adaptive - X_true)/norm(X_true))*100

%%
tic
X_FE = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);
FE_time = toc;
%FE_accuracy = (norm(X_FE - X_true)/norm(X_true))*100 % Relative error (%)

%%
tic
X_trap = trap(fhand,x_0,p,t_start,t_stop,timestep,u);
trap_time = toc
%trap_accuracy = (norm(X_trap - X_true)/norm(X_true))*100 % Relative error (%)

%% Plots

%X = X_FE;
%t = t_start:timestep:t_stop; 

X = X_trap_adaptive;
t = t_adapt;

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

%% 3 cars
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

