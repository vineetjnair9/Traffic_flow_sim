close all
clear

save_flag = 0;

N = 100;
V = 10;
psi_0 = -V;
psi_end = V;
delta_z = 1/(N+1);

phi_0 = 20*(1:N).'/(N+1) - 10;
t_i = 0;
t_f = 0.1;
delta_t_FE = 1e-5;
delta_t_TR = 1e-4;

phi_FE = forward_euler(phi_0, delta_t_FE, t_i, t_f, @(phi,t)fjpoisson(phi,t,N,V));
phi_TR = traprule_nonlinear(phi_0, delta_t_TR, t_i, t_f, @(phi,t)fjpoisson(phi,t,N,V));

phi_0 = [psi_0; phi_0; psi_end];

t_FE = t_i:delta_t_FE:t_f;
N_t_FE = length(t_FE);
phi_FE = [psi_0*ones(1,N_t_FE); phi_FE; psi_end*ones(1,N_t_FE)];

t_TR = t_i:delta_t_TR:t_f;
N_t_TR = length(t_TR);
phi_TR = [psi_0*ones(1,N_t_TR); phi_TR; psi_end*ones(1,N_t_TR)];

N_k = 10;
t_indices_FE = round(logspace(log10(1),log10(N_t_FE),N_k));
t_indices_TR = round(logspace(log10(1),log10(N_t_TR),N_k));
t_plot_FE = t_FE(t_indices_FE);
phi_plot_FE = phi_FE(:,t_indices_FE);
t_plot_TR = t_TR(t_indices_TR);
phi_plot_TR = phi_TR(:,t_indices_TR);

legend_FE = cell(N_k,1);
legend_TR = cell(N_k,1);
for i = 1:N_k
  legend_FE{i} = ['t = ' num2str(t_plot_FE(i))];
  legend_TR{i} = ['t = ' num2str(t_plot_TR(i))];
end

% Plots
z_vector = linspace(0,1,N+2);

if save_flag == 1
  figure('Visible','off')
else
  figure
end
plot(z_vector,phi_plot_FE)
xlabel('z')
ylabel('\psi')
title('Forward Euler method')
legend(legend_FE,'Location','best')
if save_flag == 1
  saveas(gcf,'FE.eps','epsc')
end

if save_flag == 1
  figure('Visible','off')
else
  figure
end
plot(z_vector,phi_plot_TR)
xlabel('z')
ylabel('\psi')
title('Trapezoidal method')
legend(legend_TR,'Location','best')
if save_flag == 1
  saveas(gcf,'TR.eps','epsc')
end
