function [F, J] = fjpss(x, t, alpha, T)

  F = sinh(alpha*x) + cos(2*pi/T*t);
  J = alpha*cosh(alpha*x);

end
