function f = human_car_behaviour_v6(x,p,u,t)

% Based on the intelligent driver model https://en.wikipedia.org/wiki/Intelligent_driver_model
% Position, speed and acceleration of lead car set by inputs 

% u(1) = position of lead car
% u(2) = speed of lead car
% x = [x_1; x_2;....;x_n; v_1; v_2;...; v_n]

nodes = length(x)/2;
f = zeros(nodes*2, 1); 

for i = 1:nodes
    
    if (i == 1) % Car 1
        delta_v = x(nodes+i) - u(2);
        net_dist = p.s_0 - exp(-(u(1) - x(i) - p.l)); 
        dis_start = p.s_0 + p.T * x(nodes+i) + ((x(nodes+i)*delta_v)/(2*sqrt(p.a*p.b))); 
        f(i) = x(nodes+i); % Velocities
        % Acceleration
        f(nodes+i) = p.a * (1 - ((x(nodes+i)/p.v_eq)^p.sigma) - ((dis_start/net_dist)^2)); 
    else         
        f(i) = x(nodes+i); % Velocities
        delta_v = x(nodes+i) - x(nodes+i-1);
        net_dist = p.s_0 - exp(-(x(i-1) - x(i) - p.l));
        dis_start = p.s_0 + p.T * x(nodes+i) + ((x(nodes+i)*delta_v)/(2*sqrt(p.a*p.b))); 
        f(nodes+i) = p.a * (1 - ((x(nodes+i)/p.v_eq)^p.sigma) - ((dis_start/net_dist)^2));
    end
        
end