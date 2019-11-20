%% Problem 2
% Part 1

x_start = 1;
t_start = 0;
t_stop = 10;
timestep = 1e-3;

T = 1; 
alpha = -3;

u = @(t) u_p2(t,T);
fhand = @(x,t) f_p2(x,u,alpha,t);
X = trap(fhand,x_start,t_start,t_stop,timestep);

%% Plotting
time = t_start:timestep:t_stop;
plot(time,X);
xlabel('Time t (s)');
ylabel('x(t)');

%% Part 2
T = 1;
alpha = -3;
u = @(t) u_p2(t,T);
fhand = @(x,t) f_p2(x,u,alpha,t);
x0 = 1;
%xf = shooting_newtonNd(fhand,x0,T);
xf = shooting_newton(fhand,x0,T)

%% Part 3 - Plot waveforms
x_start = xf;
t_start = 0;
t_stop = 10;
timestep = 1e-4;
X = trap(fhand,x_start,t_start,t_stop,timestep);
%%
time = t_start:timestep:T;
n = 1 + ceil(T/timestep);
plot(time,X(:,1:n));
xlabel('Time t (s)');
ylabel('x(t)');


