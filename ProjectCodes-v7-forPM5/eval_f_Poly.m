function f = eval_f_poly(x,p,u)
% evaluates the polynomial f(x)=p.coef(1)+p.coef(2)*x+p.coef(3)*x^2 etc...
%
% f=eval_f_poly(x,p,u);


f=0;
for i = 1:length(p.coef),
   f = f + p.coef(i).*x.^(i-1);
end




