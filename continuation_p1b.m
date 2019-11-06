function [q, xs] = continuation_p1b(f, x0,p,u)

q = 0.1:0.1:1.0;
m = max(size(x0))
errf=1e-3;
errDeltax=1e-3;
relDeltax=0.01;
MaxIter=20;
visualize=0;
FiniteDifference = 1;
p.dxFD=1e-7;
eval_Jf = 'jacobian_finite_difference';
for idx = 1:length(q)
    if idx == 1
        x0_iter(:, idx) = x0;
    else
        x0_iter(:, idx) = xs(:, idx-1);
    end
    x0iter = [x0_iter(:, idx)];
    Q = q(idx)*eye(m);
    f1 = human_car_behaviour_v5(x0iter,p,u);
    eval_f = @(x, p, u) Q*human_car_behaviour_v5(x,p,u) + (eye(m)-Q)*x;
    %     eval_f = @(Q, human_car_behavior_v5, x0iter,p,u, m) Q*human_car_behaviour_v5(x0iter,p,u) + (eye(m)-Q)*x0iter;


    
    xs(:, idx) = NewtonMethod(eval_f,x0iter,p,u,errf,errDeltax,relDeltax,MaxIter,visualize,FiniteDifference,eval_Jf);
% NewtonMethod(eval_f,x0,p,u,errf,errDeltax,relDeltax,MaxIter,visualize,FiniteDifference,eval_Jf)

end
