%% Problem 1
% Part (1)

z = [1,-0.5,zeros(1,41),-1e-13];  
fhand = @(x) fjpoly(x,z); 
guess = -1;
itpause = 7;  
%x0 = newton1d_vineet(fhand,guess,itpause)

%% Plotting f
fplot(fhand);
xlabel('Function value f(x)');
ylabel('x');

%%
maxIter = 35;
iters = 1:1:maxIter;
residual = zeros(1,length(iters));
x0 = -1;

for iter=1:length(iters)
    [f,J]=fhand(x0);            % evaluate function
    dx=-f/J;                    % solve linear system
    nf(iter)=abs(f);            % norm of f at step k+1
    ndx(iter)=abs(dx);          % norm of dx at step k+1
    x(iter)=x0+dx;              % solution x at step k+1
    x0=x(iter);                 % set value for next guess
end

close ALL
figure(1)
semilogy(nf);
xlabel('Newton iteration index k');
ylabel('|f(x_k)|');
xlim([1,33]);

figure(2)
semilogy(abs(x));
xlabel('Newton iteration index k');
ylabel('|x_k|');
xlim([1,33]);

figure(3)
semilogy(ndx);
xlabel('Newton iteration index k');
ylabel('|dx_k|');
xlim([1,33]);

%% Part (2)
z = [-1,5,-5,8];
f = @(x) fjpoly(x,z);
guess = 0;
itpause = 7;

%q = 0:0.01:0.99;
q = [0,0.2,0.4,0.6,0.8,0.99];
x_q = zeros(1,length(q));
%f_tilde = @(x) q(1) * f(x) + (1-q(1)) * x;
y = [-q(1),5*q(1),1-6*q(1),8*q(1)];
f_tilde = @(x) fjpoly(x,y);
x_q(1) = newton1d(f_tilde,guess,itpause);

for i = 2:length(q)
    y = [-q(i),5*q(i),1-6*q(i),8*q(i)];
    f_tilde = @(x) fjpoly(x,y);
    x_q(i) = newton1d(f_tilde,x_q(i-1),itpause);
end

figure(1)
plot(q,x_q);
xlabel('Value of q');
ylabel('Converged intermediate solution x(q)');

figure(2) 
hold on

for i = 1:length(q)
    y = [-q(i),5*q(i),1-6*q(i),8*q(i)];
    f_tilde = @(x) fjpoly(x,y);
    fplot(f_tilde);
end
xlabel('$$x$$','Interpreter', 'LaTeX');
ylabel('$$\tilde{f}(x,q)$$','Interpreter', 'LaTeX');
hold off
legend('q = 0','q = 0.2','q = 0.4','q = 0.6','q = 0.8','q = 0.99')

%%
function x0 = newton1d_vineet(fhand,x0,itpause,varargin)
% function newton1d(fhand,x0,itpause)
% 
% INPUTS:
%   fhand - function handle
%   x0    - initial guess
%   itpause - parameter for plotting
% 
% Use Newton's method to solve the nonlinear function
% defined by function handle fhand with initial guess x0.  
%
% itpause is parameter for plotting and defines the 
% number of Newton steps that are plotted sequentially
% pauses between sub-steps

if nargin<3
    error('Must provide three input arguments.  Type ''help newton1d'' for details');
end

tol=1e-14;          % convergence tolerance
maxIters=5000;       % max # of iterations
x00=x0;             % initial guess

% Newton loop
for iter=1:maxIters
    [f J]=fhand(x0);            % evaluate function
    dx=-f/J;                    % solve linear system
    nf(iter)=abs(f);            % norm of f at step k+1
    ndx(iter)=abs(dx);          % norm of dx at step k+1
    x(iter)=x0+dx;              % solution x at step k+1
    x0=x(iter);                 % set value for next guess
    
    if ndx(iter)/abs(x(iter)) < tol && nf(iter) < tol && ndx(iter) < tol   % check for convergence
        % check for convergence using the absolute value of the current step size
        fprintf('Converged to x=%4.12e in %d iterations\n',x0,iter);
        break; 
    end
end

if iter==maxIters % check for non-convergence
    fprintf('Non-Convergence after %d iterations!!!\n',iter); 
end

% stuff for plotting
% x=[x00,x];
% xmax=max(abs(x));
% xrange=linspace(-xmax,xmax,5000);
% [frange Jrange]=fhand(xrange);
% [fg Jg]=fhand(x);
% iters=1:iter;
% 
% % plot a few things
% if ~isempty(varargin) && strcmp(varargin{1},'off')
% else
%     plot_newton1d(x,fg,iters,ndx,xrange,frange,itpause);
% end

end