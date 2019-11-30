function [p,x_start,t_start,t_stop,max_dt_FE] = getParam_SquaredDiagonalExample;
% [p,x_start,t_start,t_stop,max_dt_FE] = getParam_SquaredDiagonalExample;

% copyright Luca Daniel, MIT 2018

% example of a 2 state system with decaying modes
p.A   = [-1 0;0 -2];
p.B   = [20 5]';
p.sqd = [-3 -5]';

x_start = [5 10]';
t_start = 0;
t_stop  = 0.1;

%note for linear systems FE may go unstable for dt>2/|fastest_eigenvalue| = 2/|-2|=1
%but in nonlinear systems FE could go unstable even for much smaller values...
max_dt_FE = 0.001; 

