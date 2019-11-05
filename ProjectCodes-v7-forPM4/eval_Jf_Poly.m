function Jf = eval_Jf_poly(x,p,u)
% evaluates the Jacobian of the polynomial f(x)=p.coef(1)+p.coef(2)*x+p.coef(3)*x^2 etc...
%
% Jf = eval_Jf_poly(x,p,u)

% copyright Luca Daniel, MIT 2018

Jf=zeros(length(x));
for i = 2:length(p.coef),
   Jf = Jf + diag((i-1).*p.coef(i).*x.^(i-2));
end


