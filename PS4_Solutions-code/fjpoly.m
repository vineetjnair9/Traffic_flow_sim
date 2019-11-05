function [f, J] = fjpoly(x, z)
% [f, J] = fjpoly(x, z)
% Evaluates the polynomial
% f(x) = \sum_i z_i * x^i
% and its derivative

f = polyval(z, x);
zprime = (length(z)-1:-1:1).*z(1:end-1);
J = polyval(zprime, x);
