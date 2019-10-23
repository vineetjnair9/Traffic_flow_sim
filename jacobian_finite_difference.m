function j = jacobian_finite_difference(eval_f,x_0, p, eval_u, t, epsilon)

n = length(x_0);
u = feval(eval_u,t);
f_0 = feval(eval_f, x_0, p, u);
f_0 = f_0';
x_perturbed = x_0; 

for i = 1:n
    x_perturbed(i) = x_0(i) + epsilon; 
    f_perturbed = feval(eval_f, x_perturbed, p, u);
    f_perturbed = f_perturbed';
    j(:, i) = (f_perturbed-f_0)/epsilon;
    x_perturbed(i) = x_0(i);
end 


