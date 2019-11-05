% Problem 2

close all
clear
clc

set(0,'defaultAxesFontSize',16)

N = 100;
V = 10;
f = @(x) fjpoisson(x,N,V); % create function handle for newtonNd to evaluate
psi0 = zeros(N,1);         % initial guess
itpause = 0;               % show all steps simultaneously
[psif, psis] = newtonNd(f,psi0);

% Remember to plot the boundaries
psifplot = [-V; psif; V];
x = linspace(0,1,N+2).';

figure
plot(x,psifplot)
xlabel('x')
ylabel('\psi')

N_psis = size(psis,2);
N_error = N_psis - 1;
k = 0:1:N_error-1;
error_norm = vecnorm(psis(:,1:N_error)-psif,Inf);
error_norm_k = error_norm(1:N_error-1);
error_norm_kp1 = error_norm(2:N_error);

figure
semilogy(k,error_norm,'-o')
xlabel('k')
ylabel('||\psi^k - \psi^*||_\infty')

figure
loglog(error_norm_k,error_norm_kp1,'-o')
xlabel('||\psi^k - \psi^*||_\infty')
ylabel('||\psi^{k+1} - \psi^*||_\infty')

error_norm_k_fit = error_norm_k(2:end);  % remove k = 0 point
error_norm_kp1_fit = error_norm_kp1(2:end);  % remove k = 0 point
params = polyfit(log(error_norm_k_fit),log(error_norm_kp1_fit),1);
order = params(1);
order

delta_psi_norm = vecnorm(psis(:,2:end)-psis(:,1:end-1),Inf);
figure
semilogy(k,delta_psi_norm,'-o')
xlabel('k')
ylabel('||\Delta\psi^k||_\infty')

F_psi_norm = NaN(N_psis,1);
kp1 = 0:1:N_psis-1;
for i = 1:N_psis
  F_psi_norm(i) = norm(f(psis(:,i)),Inf);
end
figure
semilogy(kp1,F_psi_norm,'-o')
xlabel('k')
ylabel('||F(\psi^k)||_\infty')
