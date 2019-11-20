function j = U_jacobian_finite_difference(eval_f,x_0, p, eval_u, t, epsilon)

% n = length(x_0);
u_0 = feval(eval_u,t);
n = length(u_0);
% u_0 = u_0';
f_0 = feval(eval_f, x_0, p, u_0);
f_0 = f_0';
u_perturbed = u_0;

for i = 1:n
    u_perturbed(i) = u_0(i) + epsilon; 
    f_perturbed = feval(eval_f, x_0, p, u_perturbed);
    f_perturbed = f_perturbed';
    j(:, i) = (f_perturbed-f_0)/epsilon;
    u_perturbed(i) = u_0(i);
end 


