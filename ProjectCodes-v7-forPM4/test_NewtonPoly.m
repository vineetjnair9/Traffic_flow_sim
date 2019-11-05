clear all
close all

p.coef=[0 -25 0 1]; % 0 -25x +0*x.^2 +x.^3 = x .* (x-5) .* (x+5)
eval_f='eval_f_Poly';
eval_Jf='eval_Jf_Poly';  % can use this analytical Jacobian
p.dxFD=1e-7;             % or can use finite difference jacobian with this perturbation
u = 0;						 % no inputs needed in this function
figure(3)
k=1;
x=[-8:.2:8]';
for k=1:length(x)
   f(k)    =feval(eval_f,x(k),p);
   Jf_an(k)=feval(eval_Jf,x(k),p);
   Jf_FD(k)=eval_Jf_finiteDifference(eval_f,x(k),p,u);
   k=k+1;
end
plot(x,f,'r')
hold on
plot(x,Jf_an,'g')
plot(x,Jf_FD,'.b')
figure(4)
plot(x,Jf_an - Jf_FD)



x0=[ -10 -6 -8 -4 -2 2 4 6 8 10]';
errf=1e-3;
errDeltax=1e-3;
relDeltax=0.01;
MaxIter=20;
visualize=1;
figure(1)

%test with analytical Jacobian and provide eval_Jf function
FiniteDifference=0;  
figure(1)
[x_analytic,converged,errf_k,errDeltax_k,relDeltax_k,iterations] = NewtonMethod(eval_f,x0,p,u,errf,errDeltax,relDeltax,MaxIter,visualize,FiniteDifference,eval_Jf)

%test with finite difference Jacobian
FiniteDifference=1;  
figure(2)
[x_finiteDifference,converged,errf_k,errDeltax_k,relDeltax_k,iterations] = NewtonMethod(eval_f,x0,p,u,errf,errDeltax,relDeltax,MaxIter,visualize,FiniteDifference,eval_Jf)

difference=norm(x_analytic-x_finiteDifference)


