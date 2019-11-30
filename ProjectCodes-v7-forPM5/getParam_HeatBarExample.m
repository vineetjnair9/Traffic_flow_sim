function [p,x_start,t_start,t_stop,max_dt_FE] = getParam_HeatBarExample(N);
% [p,x_start,t_start,t_stop,max_dt_FE] = getParam_HeatBarExample(N);


% copyright Luca Daniel, MIT 2018

% example of a heat bar 
gamma =0.1; %related to thermal capacitance per unit length of the bar
km    =0.1; %related to thermal conductance through metal per unit length of the bar
ka    =0.1; %related to thermal conductance to air per unit length of the bar

dz=1/N; %notice what stays constant is the total length of the bar
        %not the length of the discretization section.
        %results should not ideally depend on the number of sections
        %for a large enough number of sections
Cstore = gamma*dz; %the longer the section the larger the storage
Rc     = (1/km)*dz; %the longer the section the larger the resistance
Rloss  = (1/ka)/dz; %the longer the section the larger the loss
                    %hence the smaller the resistance to air
p.A    = zeros(N,N);
% coupling resistors Rc between i and j=i+1
for i = 1:N-1,
   j=i+1;
   p.A(i,i) = p.A(i,i)+(+1/Rc);
   p.A(i,j) = p.A(i,j)+(-1/Rc);
   p.A(j,i) = p.A(j,i)+(-1/Rc);
   p.A(j,j) = p.A(j,j)+(+1/Rc);
end
% leakage resistor Rloss between i and ground
for i = 1:N,
   p.A(i,i) = p.A(i,i) + 1/Rloss;
end

p.sqd   = eye(N,1);
p.B     = zeros(N,1);
p.B(1,1)= 1;
%p.B(7,1)= 3;


p.A     = -p.A/Cstore; % note this will give a 1/dz^2 in A
							  % also pay attention to the negative sign
p.B     = p.B/Cstore;  % note this is important to make sure results
                       % will not depend on the number of sections N
                       	
x_start = zeros(N,1);
t_start = 0;

slowest_eigenvalue = min(abs(eig(p.A)));
fastest_eigenvalue = max(abs(eig(p.A)));

% to see steady state need to wait until the slowest mode settles
t_stop = (slowest_eigenvalue*2);    %use this to wait until slowest mode

% usually Forward Euler is unstable for timestep>2/fastest_eigenvalue
max_dt_FE = 1/fastest_eigenvalue;
