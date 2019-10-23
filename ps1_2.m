%% Part (a) - MATLAB data file generation
% Without enforcing current flow at end

delta_z = 0.01; % Spatial discretization step along the bar
k_m = 0.2; % Thermal conductivity along bar (W/mK)
k_a = 0.005; % Thermal leakage from bar to surronding air (W/m^3K)
R_m = (delta_z^2)/k_m; % Conductive thermal resistance
R_a = (1/k_a); % Convective thermal resistance
T_air = 294; % Air temperature (K) chosen as ground/reference voltage
T_ice = 273; % Heat sink temperature (K)

V_0 = T_ice - T_air; % Voltage source (K) used to enforce boundary condition at z=0

n = (1/delta_z); 
N = n; % No. of nodes
B = 2*n; % No. of thermal resistor branches with unknown currents

R = zeros(3,B); % Matrix of resistor values
Isource = zeros(3,n+1);

for i = 1:n
% 1st populate all conductive thermal resistances    
    R(1,i) = R_m;

    if (i == 1)
        R(2,i) = 0;
    else
        R(2,i) = i-1;
    end
    
    R(3,i) = i;   
    
end

for i = n+1:2*n
% Then populate all convective resistances
    R(1,i) = R_a;
    R(2,i) = i-n;
    R(3,i) = 0;
end

for i = 1:n+1
    if (i == 1)
        Isource(1,i) = V_0/R_m; % Equivalent current source to replace voltage source
    else
        Isource(1,i) = 10; % Heat generated in the bar [W/m^3]
    end
    
    % Nodes at which current sources originate
    Isource(2,i) = 0;
    
    % Nodes towards which current sources flow
    if (i == 1)
        Isource(3,i) = 1;
    else
        Isource(3,i) = i-1;
    end
end

save('ps1_p2_thermalcircuit.mat','R','Isource')

%% Part (b)
load('ps1_p2_thermalcircuit.mat');
nodes = max(max(R(2,:),R(3,:))); % No. of nodes
branches = size(R,2);
E = zeros(nodes,branches); % Node-branch incidence matric (KCL)
Is = zeros(nodes,1); % RHS vector with source currents
Alpha = eye(branches);

tic

for N = 1:nodes % Nodes with unknown voltage
    
    % All current sources in direction from n1_1 to n1_2
    for i = 1:size(Isource,2)
        if ((Isource(2,i)) == N)
            Is(N) = Is(N) - Isource(1,i);
        elseif ((Isource(3,i)) == N)
            Is(N) = Is(N) + Isource(1,i);
        else
            continue
        end
    end
    
    for B = 1:branches % Branches with unknown currents
        % Current convention
        % Currents leaving nodes: +ve
        % Currents entering node: -ve
        
        % Assume currents flow in direction from lower to higher numbered nodes
                
        if (R(2,B) == N)
            if (R(3,B) > N)
                E(N,B) = 1;
            else
                E(N,B) = -1;
            end
        elseif (R(3,B) == N)
            if (R(2,B) > N)
                E(N,B) = 1;
            else
                E(N,B) = -1;
            end
        else
            continue
        end
        
        Alpha(B,B) = 1/R(1,B); % Matrix relating branch voltages & currents
        
    end
end

A = [eye(branches) -Alpha*E'; E zeros(nodes)];
b = [zeros(branches,1); Is];
sol_nodebranch = A\b;
branch_currents = sol_nodebranch(1:B,1);
nodal_voltages = sol_nodebranch(B+1:B+N,1);
temp = zeros(size(nodal_voltages,1),1);

T_air = 294; % (K)
T_ice = 273; % (K)

temp = nodal_voltages + T_air;
temp = [273; temp];

z = 0:delta_z:1;
plot(z,temp);
xlabel('z position [m]');
ylabel('Temperature [K]');

time_10 = toc;

%%
error = zeros(1,length(temp))';
index = 1;
for i = 1:length(temp)
    error(i) = abs(temp(i) - temp_base(index))/temp_base(index);
    index = index + (5000/(length(temp)-1));
end

rel_error = sum(error)*100;


