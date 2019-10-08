function [sensitivity] = FD_sensitivity(p,eps, n, x_0, t_start, t_stop, timestep, s_0, T, a, b, v_eq, sigma)
% c_t chosen so that we can look at the average velocity of all the cars.
c_t(1:n) = 0;
c_t(n+1:2*n) = 1/n;
p2 = p;
if (s_0 == 1)
    p2.s_0 = p2.s_0 + eps*p2.s_0;
end
if (T == 1)
    p2.T = p2.T + eps*p2.T;
end
if (a == 1)
    p2.a = p2.a + eps*p2.a;
end
if (b == 1)
    p2.b = p2.b + eps*p2.b;
end
if (v_eq == 1)
    p2.v_eq = p2.v_eq + eps*p2.v_eq;
end
if (sigma == 1)
    p2.sigma = p2.sigma + eps*p2.sigma;
end


sensitivity = c_t*(ForwardEuler('human_car_behaviour', x_0, p2, 'human_car_input', t_start, t_stop, timestep, false)...
        - ForwardEuler('human_car_behaviour', x_0, p, 'human_car_input', t_start, t_stop, timestep, false))/eps;


end

