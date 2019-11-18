function [F, J] = fjpss_shooting(x_0, delta_t, alpha, T)

  t_i = 0;
  t_f = T;

  x = traprule_nonlinear(x_0, delta_t, t_i, t_f, @(x,t)fjpss(x,t,alpha,T));
  x = x(:,end);
  F = x - x_0;
  epsilon = sqrt(eps);
  x_0_eps = x_0 + epsilon;
  x_eps = traprule_nonlinear(x_0_eps, delta_t, t_i, t_f, @(x,t)fjpss(x,t,alpha,T));
  x_eps = x_eps(:,end);
  J = (x_eps-x)/epsilon - 1;

end
