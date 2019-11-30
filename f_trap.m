function Fnew = f_trap(dt,gamma,f,x,u,t)
    F = f(x,u,t);
    Fnew = x - (dt/2)*F - gamma;
end
