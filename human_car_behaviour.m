function f = human_car_behaviour(x,p,u)

%Based on the intelligent driver model https://en.wikipedia.org/wiki/Intelligent_driver_model

% x = [x_1; x_2;....;x_n; v_1; v_2;...; v_n]

% Question: How to model the first car? 
% Question: What can be a true initial point? 
% Question: Why is the ditance between cars more that minimum distance?
% Question: Why does the second car reach equilibrium at a lower velocity? 
% Question: What inputs can we introduce to the model? 
%      - traffic 'shocks' = random slow-downs of the car in front. We can
%      show the propagation of the change of behavior of the first car.

nodes = length(x)/2; 
f = zeros(nodes*2, 1); 


for i = 1:nodes
    f(i) = x(nodes+i); % Velocities
    if i == 1
        f(nodes+i) = 0; 
    else 
        delta_v = x(nodes+i) - x(nodes+i-1);
        net_dist = x(i-1) - x(i) - p.l;
        dis_start = p.s_0 + p.T * x(nodes+i) + ((x(nodes+i)*delta_v)/(2*sqrt(p.a*p.b))); 
        f(nodes+i) = p.a * (1 - ((x(nodes+i)/p.v_eq)^p.sigma) - ((dis_start/net_dist)^2));
    end 

end