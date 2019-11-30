a = 0.73;
b = 1.67;
v_max = 120*(5/18); % v_eq
s_0 = 2;
l = 5;

syms v1 v2 x1 x2

v2_dot = @(v1,v2,x1,x2) a*(1 - (v2/v_max)^4 - ((s_0 + 1.6*v2 + (v2*(v2 - v1))/2*sqrt(a*b))/(x1 - x2 - l))^2);
%% Jacobian elements
diff(v2_dot,x1)
diff(v2_dot,x2)
diff(v2_dot,v1)
diff(v2_dot,v2)