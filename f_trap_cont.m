function Fnew = f_trap_cont(dt,gamma,f,x,u,t,q)
    F = f(x,u,t);
    Fnew = x - q*(dt/2)*F - gamma;
end
