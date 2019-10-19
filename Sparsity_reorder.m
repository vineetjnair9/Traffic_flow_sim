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

% What are our input(s)?

%--------------------------------
%    Initiate state variables  
%--------------------------------

% x = [x_1; x_2;....;x_n; v_1; v_2;...; v_n]

num_cars = 2:2:50;
sparsity = zeros(1,length(num_cars));

for j = 1:length(num_cars) % 25 runs
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

    %--------------------------------
    %    Forward Euler debugging  
    %--------------------------------
    t_start = 0; 
    t_stop = 100; 
    timestep = 0.1;
    iterations = (t_stop/timestep) + 1;
    
    A = jacobian_finite_difference('human_car_behaviour',x_0, p, 'human_car_input', 100, 0.001);
    A_reordered = A;
    A_reordered(1:num_cars(j),:) = A(num_cars(j)+1:end,:);
    A_reordered(num_cars(j)+1:end,:) = A(1:num_cars(j),:);
    Non_zeros = nnz(A_reordered);
    sparsity(j) = (Non_zeros/(2*num_cars(j))^2)*100;
end
    
plot(num_cars,sparsity);
xlabel('Number of cars');
ylabel('Sparsity ratio (%)');

% X = ForwardEuler('human_car_behaviour',x_0,p,'human_car_input',t_start,t_stop,timestep,false);
% t = t_start:timestep:t_stop; 
% 
% hold on
% figure(1)  
% for i = 1:num_cars
%     plot(t,X(i,:));
% end
% xlabel('Time [s]');
% ylabel('Position along road [m]');
% hold off
% 
% hold on
% figure(2)  
% for i = num_cars+1:2*num_cars
%     plot(t,X(i,:));
% end
% xlabel('Time [s]');
% ylabel('Speed of car [m/s]');

%% Estimating sparsity of Jacobian matrix
spy(A_reordered)
