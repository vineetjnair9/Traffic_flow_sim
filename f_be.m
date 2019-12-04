function Fnew = f_be(dt,gamma,f,x,u,t)
    F = f(x,u,t);
    Fnew = x - dt*F - gamma;
end
