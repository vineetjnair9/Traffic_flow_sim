function f = curlyf(init_f,m, x,p,u, Q)
    f = Q*init_f + (eye(m) - Q)*x;

end

