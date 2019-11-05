function u = eval_u_step(t);
% generates the value of the input u at time t
% corresponding to a step of magnitude 1
%
% u = eval_u_step(t);


if t <0
   u = 0;
else 
   u = 1;
end

