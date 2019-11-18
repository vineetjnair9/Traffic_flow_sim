close all
clear
clc

save_flag = 0;
methods = [1,2];

% System description
N = 500;
kappa_a = 0.1;
kappa_m = 0.1;
gamma = 0.1;
t_i = 0;
t_f = 10;
delta_t = 0.001;

z = linspace(0,1,N);
t = t_i:delta_t:t_f;
delta_z = 1/(N-1);

A = -2*eye(N) + diag(ones(N-1,1),1) + diag(ones(N-1,1),-1);
A(1,1) = -1;
A(end,end) = -1;
A = (kappa_m/(gamma*(delta_z^2)))*A;
A = A - (kappa_a/gamma)*eye(N);

b = zeros(N,1);
b(1) = 1/(gamma*delta_z);

c = zeros(N,1);
c(end) = 1;

u = @(t) t > 0;

qs = [2, 5, 10];

N_t = length(t);
N_q = length(qs);
N_methods = length(methods);

times_g = NaN(N_methods,N_q);
times_s = NaN(N_q+1,1);
mem_g = NaN(N_methods,N_q);
mem_s = NaN(N_q+1,1);

% Original system solution
sys_full = ss(A, b, c.', 0);

x_0 = zeros(N,1);
%profile on -memory
tic
x_full = traprule_LTI(x_0, delta_t, t_i, t_f, A, b, u);
times_s(end) = toc;
%p = profile('info');
%mem_s(end) = get_peak_mem(p,'traprule_LTI');
y_full = c.'*x_full;

f_min = 1e-2;
f_max = 5e1;
f = logspace(log10(f_min),log10(f_max),100).';

for i = 1:N_methods

  y_q = NaN(N_q+1,N_t);
  y_q(end,:) = y_full;

  method = methods(i);

  if method == 2  % POD
    x_0_coarse = zeros(N,1);
    delta_t_coarse = 0.05;
    W = traprule_LTI(x_0_coarse, delta_t_coarse, t_i, t_f, A, b, u);
  end

  for j = 1:N_q

    q = qs(j);

    % profile on -memory
    tic
    if method == 1  % eigenmode truncation
      [A_, b_, c_, sys] = eigTrunc(A, b, c, q);
    elseif method == 2  % POD
      [A_, b_, c_, sys] = pod(A, b, c, q, W);
    end
    times_g(i,j) = toc;
    % p = profile('info');

    % if method == 1
    %   mem_g(i,j) = get_peak_mem(p,'eigTrunc');
    % elseif method == 2
    %   mem_g(i,j) = get_peak_mem(p,'pod');
    % end

    figure(3*method-2)
    hold on
    bodePlot(f,sys)
    hold off

    x_0 = zeros(q,1);
    if method == 1  % measure simulation time and memory for eigenmode truncation
      % profile on -memory
      tic
    end
    x = traprule_LTI(x_0, delta_t, t_i, t_f, A_, b_, u);
    if method == 1
      times_s(j) = toc;
      % p = profile('info');
      % mem_s(j) = get_peak_mem(p,'traprule_LTI');
    end

    y = c_*x;
    y_q(j,:) = y;

    figure(3*method-1)
    hold on
    plot(t,y)
    hold off
    xlabel('t')
    ylabel('y')

  end

  figure(3*method-2)
  hold on
  bodePlot(f,sys_full)
  hold off
  legend('q = 2', 'q = 5', 'q = 10', 'Full', 'Location', 'southwest')

  if method == 1
    title('Eigenmode truncation')
    if save_flag == 1
      saveas(gcf,'Eigenmode_freq.eps','epsc')
    end
  elseif method == 2
    title('Proper orthogonal decomposition')
    if save_flag == 1
      saveas(gcf,'POD_freq.eps','epsc')
    end
  end

  figure(3*method-1)
  hold on
  plot(t,y_full)
  hold off
  legend('q = 2', 'q = 5', 'q = 10', 'Full', 'Location', 'southeast')

  if method == 1
    title('Eigenmode truncation')
    if save_flag == 1
      saveas(gcf,'Eigenmode_time.eps','epsc')
    end
  elseif method == 2
    title('Proper orthogonal decomposition')
    if save_flag == 1
      saveas(gcf,'POD_time.eps','epsc')
    end
  end

  y_d = y_q(1:N_q,:) - y_q(end,:);
  y_d = abs(y_d);

  figure(3*method)
  semilogy(t,y_d)
  xlabel('t')
  ylabel('|y_q(t) - y(t)|')
  ylim([1e-14 5e-1])
  legend('q = 2', 'q = 5', 'q = 10', 'Location', 'best')

  if method == 1
    title('Eigenmode truncation')
    if save_flag == 1
      saveas(gcf,'Eigenmode_err.eps','epsc')
    end
  elseif method == 2
    title('Proper orthogonal decomposition')
    if save_flag == 1
      saveas(gcf,'POD_err.eps','epsc')
    end
  end

end

% profile off

times_g
times_s
mem_g
mem_s
