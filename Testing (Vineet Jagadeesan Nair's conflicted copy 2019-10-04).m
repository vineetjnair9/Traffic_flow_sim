%--------------------------------
%    Initiate system parameters 
%--------------------------------

p.l = 5; %Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars 
p.T = 1.5; % Safe time headway 
p.a = 0.73; % Maximum allowed acceleration 
p.b = 1.67; % Comfortable deceleration 
p.v_eq = 30; % Desired street speed (m/s)
p.sigma = 4; %Acceleration exponent

%--------------------------------
%    Initiate state variables  
%--------------------------------

x_0 = [16,8,0,30,0,0];

%--------------------------------
%    Forward Euler debugging  
%--------------------------------
t_start = 0; 
t_stop = 200; 
timestep = 0.1;
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


