function j = jacobian_finite_difference(eval_f,x_0, p, eval_u, t, epsilon)
n = length(x_0);
u = feval(eval_u,t);
f_0 = feval(eval_f,x_0, p, u);
f_0 = f_0';
x_purterbed = x_0; 
for i = 1:n
    x_purterbed(i) = x_0(i) + epsilon; 
    f_purterbed = feval(eval_f, x_purterbed, p, u);
    f_purterbed = f_purterbed';
    j(:, i) = (f_purterbed-f_0)/epsilon;
    x_purterbed(i) = x_0(i);
end 


