% Problem 1b

close all
clear
clc
set(0,'defaultAxesFontSize',20)
set(0,'DefaultLineLineWidth',2)

% Create function handle for specified polynomial
z = zeros(1, 4);
z(1) = -1;
z(2) = 5;
z(3) = -5;
z(4) = 8;
f = @(x) fjpoly(x,z);

% Initial guess
x0 = 0;

% Newton
% xf = newton1d(f,x0,0);

% Continuation Scheme
[q, xs] = continuation_p1b(z,x0);

figure;
hold all;
plot(q, xs, 'ro--');
plot(q, 4.268*ones(length(q), 1), 'ko--');
legend('Numerical Solution', 'Analytical Solution');
xlabel('q');
ylabel('x(q)');
xlim([min(q) max(q)])
figure;
hold all
xrange = linspace(-20,20,5000);
for idx = 1:length(q)

    z_it = q(idx)*z;
    z_it(3) = z_it(3) + (1 - q(idx));

    f_it = @(x) fjpoly(x, z_it);
    [frange, Jrange] = f_it(xrange);
    plot(xrange, frange);

end
leg = legend({'q=0.1','q=0.2','q=0.3','q=0.4','q=0.5','q=0.6','q=0.7','q=0.8','q=0.9','q=1.0'}, 'FontSize',12);
set(leg,'location','best')
xlabel('x');
ylabel('f(x)');
