function Fnew = f_trap(dt,gamma,f,x,t)
    F = f(x,t);
    Fnew = x - (dt/2)*F - gamma;
end
