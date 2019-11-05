function x0 = newton1d(fhand,x0,itpause,varargin)
% function newton1d(fhand,x0,itpause)
%
% INPUTS:
%   fhand - function handle
%   x0 - initial guess
%   itpause - parameter for plotting
%
% Use Newton's method to solve the nonlinear function
% defined by function handle fhand with initial guess x0.
%
% itpause is parameter for plotting and defines the
% number of Newton steps that are plotted sequentially
% pauses between sub-steps.

if nargin < 3
    error('Must provide three input arguments.  Type ''help newton1d'' for details');
end

tol = 1e-13;          % convergence tolerance
rel_tol = 1e-13;
maxIters = 500;       % max # of iterations
x00 = x0;             % initial guess

% Newton loop
for iter = 1:maxIters
    [f, J] = fhand(x0);           % evaluate function
    dx = -f/J;                    % solve linear system
    nf(iter) = abs(f);            % norm of f at step k+1
    ndx(iter) = abs(dx);          % norm of dx at step k+1
    x(iter) = x0 + dx;            % solution x at step k+1
    rel_err = abs(dx/x0);
    x0 = x(iter);                 % set value for next guess
    if nf(iter) < tol && rel_err < rel_tol % check for convergence
        fprintf('Converged to x=%4.12e in %d iterations\n',x0,iter);
        break
    end
end

if iter == maxIters % check for non-convergence
    fprintf('Non-Convergence after %d iterations!!!\n',iter);
end

% Stuff for plotting
x = [x00,x];
xmax = max(abs(x));
xrange = linspace(-xmax,xmax,5000);
[frange, Jrange] = fhand(xrange);
[fg, Jg] = fhand(x);
iters = 1:iter;

% Plot a few things
if ~isempty(varargin) && strcmp(varargin{1},'off')
else
    plot_newton1d(x,fg,iters,ndx,xrange,frange,itpause);
end
