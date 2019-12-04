function X = SelectedForwardEuler(eval_f,x_start,p,eval_u,t_start,t_stop,timestep,times)

X_iter = x_start; % State variables at each time step
t = t_start;


for n=1:ceil((t_stop-t_start)/timestep)

    dt = min(timestep, (t_stop-t));
    t = t + dt;
    u = feval(eval_u, t);
    f = feval(eval_f, X_iter, p, u);
    %    X(:,n+1)= X(:,n) +  dt * f;
    X_iter = X_iter + dt*f;
    for i = 1:size(times, 2)
        if t == times(i)
            X(:, i) = X_iter;
        end
    end
    

end
