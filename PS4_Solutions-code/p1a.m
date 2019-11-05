% Problem 1a solution

close all
clear
clc
set(0,'defaultAxesFontSize',20)

% Create function handle for specified polynomial
z = zeros(1, 44);
z(1) = 1;
z(2) = -0.5;
z(44) = -10^(-13);
f = @(x) fjpoly(x,z);

% Initial guess
x0 = -1;

% Newton
xf = newton1d(f,x0,0);

% Verify using fsolve
fopts = optimset('TolFun',1e-40,'TolX',1e-40);
xf2 = fsolve(f, x0, fopts);
