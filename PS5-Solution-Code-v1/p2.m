close all
clear

save_flag = 0;

alpha = -3;
T = 1;

x_0 = 1;
t_i = 0;
t_f = 10;
delta_t = 1e-3;

x = traprule_nonlinear(x_0, delta_t, t_i, t_f, @(x,t)fjpss(x,t,alpha,T));
t = t_i:delta_t:t_f;

if save_flag == 1
  figure('Visible','off')
else
  figure
end
plot(t,x)
xlabel('t')
ylabel('x')
title('Trapezoidal integration')
if save_flag == 1
  saveas(gcf,'x_TR.eps','epsc')
end

[x_0_shooting, ~] = newtonNd(@(x_0)fjpss_shooting(x_0,delta_t,alpha,T), x_0);
x_shooting = traprule_nonlinear(x_0_shooting, delta_t, 0, T, @(x,t)fjpss(x,t,alpha,T));
t_shooting = 0:delta_t:T;

if save_flag == 1
  figure('Visible','off')
else
  figure
end
plot(t_shooting,x_shooting)
xlabel('t')
ylabel('x')
title('Shooting-Newton')
if save_flag == 1
  saveas(gcf,'x_shooting.eps','epsc')
end
