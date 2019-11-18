function x = traprule_LTI(x_0, delta_t, t_i, t_f, A, b, u)

% x_0 = initial condition
% delta_t = time step
% t_i = initial time
% t_f = final time
% A, b and u are defined as in the following LTI dynamical system:
% dx(t)/dt = A*x(t) + b*u(t)

N = length(x_0);
L = (t_f-t_i)/delta_t;
x = NaN(N,L+1);
I = eye(N);

temp = 1/2*delta_t*A;
temp_1 = I - temp;
temp_2 = I + temp;
temp_3 = 1/2*delta_t*b;

t = t_i;
x(:,1) = x_0;

for i = 2:L+1
    t = t + delta_t;
    rhs = temp_2*x(:,i-1) + temp_3*(u(t)+u(t-delta_t));
    x(:,i) = temp_1\rhs;
end
