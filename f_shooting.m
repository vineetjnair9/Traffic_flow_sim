function f = f_shooting(fhand,x_start,T)

    timestep = 1e-3; % (s)
    X = trap(fhand,x_start,0,T,timestep);
    
    n = ceil(T/timestep);
    X = X(:,n);
    f = X;
end