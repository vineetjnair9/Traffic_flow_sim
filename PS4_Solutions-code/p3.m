%% Problem 3
%Part a & b

close all
clear
clc

set(0,'defaultAxesFontSize',16)

save_flag = 0;

N = 100;
V = 10;
f = @(x) fjpoisson(x,N,V); % create function handle for newtonNdGCR to evaluate
psi0 = zeros(N,1);         % initial guess
itpause = 0;               % show all steps simultaneously
delta = 0.1;
epsilon = 1e-3;
[psif, psis] = newtonNdGCR(f,psi0,delta,epsilon);

% Remember to plot the boundaries
psifplot = [-V; psif; V];
x = linspace(0,1,N+2).';

if save_flag == 1
  figure('Visible','off')
else
  figure
end
plot(x,psifplot)
xlabel('x')
ylabel('\psi')
if save_flag == 1
  saveas(gcf,'p30.eps','epsc')
end

N_psis = size(psis,2);
N_error = N_psis - 1;
k = 0:1:N_error-1;
error_norm = vecnorm(psis(:,1:N_error)-psif,Inf);
error_norm_k = error_norm(1:N_error-1);
error_norm_kp1 = error_norm(2:N_error);

if save_flag == 1
  figure('Visible','off')
else
  figure
end
semilogy(k,error_norm,'-o')
xlabel('k')
ylabel('||\psi^k - \psi^*||_\infty')
if save_flag == 1
  saveas(gcf,'p31.eps','epsc')
end

if save_flag == 1
  figure('Visible','off')
else
  figure
end
loglog(error_norm_k,error_norm_kp1,'-o')
xlabel('||\psi^k - \psi^*||_\infty')
ylabel('||\psi^{k+1} - \psi^*||_\infty')
if save_flag == 1
  saveas(gcf,'p32.eps','epsc')
end

params = polyfit(log(error_norm_k),log(error_norm_kp1),1);
order = params(1);
order

F_norm_ratio = NaN(N_psis,1);
kp1 = 0:1:N_psis-1;
for i = 1:N_psis
  F_norm_ratio(i) = norm(f(psis(:,i)),Inf);
end
F_norm_ratio = F_norm_ratio / norm(f(psis(:,1)),Inf);

% Standard Newton
[~, psiss] = newtonNd(f,psi0);
N_psiss = size(psiss,2);
F_norm_ratio_s = NaN(N_psiss,1);
kp1s = 0:1:N_psiss-1;
for i = 1:N_psiss
  F_norm_ratio_s(i) = norm(f(psiss(:,i)),Inf);
end
F_norm_ratio_s = F_norm_ratio_s / norm(f(psiss(:,1)),Inf);

if save_flag == 1
  figure('Visible','off')
else
  figure
end
semilogy(kp1,F_norm_ratio,'-o',kp1s,F_norm_ratio_s,'-o')
xlabel('k')
ylabel('||F(\psi^k)||_\infty / ||F(\psi^0)||_\infty')
legend('Jacobian-free','Standard')
if save_flag == 1
  saveas(gcf,'p33.eps','epsc')
end

%% Part C
%use a dynamically set delta function set in delta_fun, based off the
%newton iterations
%episilon is dynamically set based on machine precision and the jacobian
%perturbation
[psif_dynS, psis_dynS] = newtonNdGCR_dynD(f,psi0,@delta_fun);

N_psis_opt = size(psis_dynS,2);
N_error_opt = N_psis_opt - 1;
error_norm_opt = vecnorm(psis_dynS(:,1:N_error_opt)-psif_dynS,Inf);
error_norm_k_opt = error_norm_opt(1:N_error_opt-1);
error_norm_kp1_opt = error_norm_opt(2:N_error_opt);

N_psis = size(psis_dynS,2);
F_norm_ratio_dynS = NaN(N_psis,1);
kp1dynS = 0:1:N_psis-1;
for i = 1:N_psis
  F_norm_ratio_dynS (i) = norm(f(psis_dynS(:,i)),Inf);
end
F_norm_ratio_dynS  = F_norm_ratio_dynS  / norm(f(psis_dynS(:,1)),Inf);

figure;
semilogy(kp1,F_norm_ratio,'-o',kp1s,F_norm_ratio_s,'-o',kp1dynS,F_norm_ratio_dynS,'-o')
xlabel('k')
ylabel('||F(\psi^k)||_\infty / ||F(\psi^0)||_\infty')
legend('Jacobian-free','Standard','Jacobian-free \newlineDynamic Delta & Epsilon')
if save_flag == 1
  saveas(gcf,'p34.eps','epsc')
end

if save_flag == 1
  figure('Visible','off')
else
  figure
end
loglog(error_norm_k_opt,error_norm_kp1_opt,'-o')
xlabel('||\psi^k - \psi^*||_\infty')
ylabel('||\psi^{k+1} - \psi^*||_\infty')


