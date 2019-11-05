% example1d.m
% script to show how newton1d(), fjpoly(), and fsolve(), work
clear

% For more information on use of newton1d(), fjpoly(), and fsolve():
% help newton1d
% help fjpoly
% help fsolve

% For more information on use of the @ symbol,
% implicit functions, and function handles:
% help function_handle

%% Example of newton1d
z = [5,4,2,7];          % defines the poly f(x)=5x^3+4x^2+2x+7
f = @(x) fjpoly(x,z);   % Create function handle for newton1d to evaluate
x0 = 2;                 % initial guess
itpause = 7;            % show 7 steps of Newton algorithm (one at a time)
xf = newton1d(f,x0,itpause);

%% Example of fsolve
% Define options structure fopts to set tolerances for fsolve
fopts = optimset('TolFun',1e-12,'TolX',1e-12);
xf2 = fsolve(f,x0, fopts);

% Show that newton1d and fsolve agree on solution
 xf2 - xf
