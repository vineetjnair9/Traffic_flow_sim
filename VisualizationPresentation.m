%% pre load data
X_100_nominal = load('response100.mat');
X_100_input = load('response100_varied_input.mat');
fiftycars = load('response50_fixed2.mat');
X500full = load('response500full.mat');
X_100_V = load('response100V.mat');
X_global_T = load('response100_param_T_global.mat');



%%  Live runtime = 5.0697 s with 5000 cars. 
p.l = 5; % Car length (can be speed limit) 
p.s_0 = 2; % Minimum allowable distance between cars  = desired stopping/jam distance (m) 
p.T = 1.6; % Safe time headway/gap (s) - 1.5
p.a = 0.73; % Maximum allowed acceleration (m/s^2) - 1.4
p.b = 1.67; % Comfortable deceleration (m/s^2) - 2
p.v_eq = 80*(5/18); % Desired street speed (m/s)
p.sigma = 4; % Acceleration exponent 
p.dxFD=1e-7; % For finite difference Jacobian

num_cars = 5000;
x_0 = zeros(2*num_cars,1);

for i = 1:num_cars
    % Assume all cars start out evenly spaced by 10 m
    % Last follower car starts at 50 m
    x_0(i) = 50 + (num_cars-i)*20; 
end

for i = num_cars+1:2*num_cars
    % Assume speeds of all cars randomly initialized between 20 and 30 m/s (according to uniform distribution)
    x_0(i) = 20 + (30-20)*rand(1);
end

t_start = 0; 
t_stop = 180;

timestep = 0.1;
% times = [1, 30, 60, 120, 180];
tic;
Xresponse = ForwardEuler('human_car_behaviour_v5',x_0,p,'constant_speed_input',t_start,t_stop,timestep,false);

time_took = toc



%% try_animating road

% fiftycars = load('response50_fixed2.mat');
Xresponse = fiftycars.Xresponse;

% fixing_y_value = size(Xresponse, 2);
num_cars = size(Xresponse, 1)/2;

fixing_y_value = ones(num_cars, size(Xresponse,2));
 
for i = 1:30:size(Xresponse, 2) 
    plot(Xresponse(1:num_cars, i),fixing_y_value(1:num_cars,i),'or','MarkerSize',7,'MarkerFaceColor','r')
    xlim([0, 6000])
    ylim([0.9, 1.1])
    yticks([1])
    x0=5;
    y0=350;
    width=3000;
    height=100;
    set(gcf,'position',[x0,y0,width,height])
    title('Position of cars')

    drawnow
end


%% setting up the road section and the disretization of the road section  %% heat map snapshots.

road_section_length = 200;
road_sectionX = 0:road_section_length:6000; % for the others
t_start = 0;
t_stop = 180;
timestep = 1E-1;

% X500full = load('response500full.mat');

t = 120;
X500 = X500full.Xresponse;
num_cars = 500;
timestep = 1E-1;

figure(1)
subplot(2, 2, [1,2])
cars_on_road = howmanycars(X500, num_cars, road_sectionX, t/timestep, road_section_length)/road_section_length;
hbl_density_input = heatmap(cars_on_road);
hbl_density_input.GridVisible = 'off';
hbl_density_input.Colormap = cool;
hbl_density_input.CellLabelColor = 'none';
hbl_density_input.XData = road_sectionX; 
hbl_density_input.YData = ['Density [cars/m]'];
hbl_density_input.XLabel = 'Distance along the road section [m]';
% hbl_density_input.Title = 'Density along 200 m road sections at t = 120 s';
set(gca,'FontSize',15);
hbl_density_input.XDisplayLabels = {'0', ' ', ' ', ' ', ' ','1000', ' ', ' ', ' ', ' ','2000', ' ', ' ', ' ', ' ','3000', ' ', ' ', ' ', ' ','4000', ' ', ' ', ' ', ' ','5000', ' ', ' ', ' ', ' ','6000'};
veloc_on_road = velocityheatmap(X500, num_cars, road_sectionX, t/timestep, road_section_length);
subplot(2, 2, [3, 4])
flow_cars = cars_on_road.*veloc_on_road;
hbl_flow = heatmap(flow_cars);
hbl_flow.GridVisible = 'off';
hbl_flow.Colormap = cool;
hbl_flow.CellLabelColor = 'none';
hbl_flow.XData = road_sectionX;
hbl_flow.YData = ['Flow [cars/s]'];
hbl_flow.XLabel = 'Distance along the road section [m]';
% hbl_flow.Title = 'Flow along 200 m road sections at t = 120 s';
hbl_flow.XDisplayLabels = {'0', ' ', ' ', ' ', ' ','1000', ' ', ' ', ' ', ' ','2000', ' ', ' ', ' ', ' ','3000', ' ', ' ', ' ', ' ','4000', ' ', ' ', ' ', ' ','5000', ' ', ' ', ' ', ' ','6000'};

set(gca, 'FontSize', 15);

%% loading data. %% density of cars when there's a crash.
% X_100_nominal = load('response100.mat');
% X_100_input = load('response100_varied_input.mat');

timestep = 0.0001;

Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;
Xinputs = X_100_input.Xresponse;
num_cars2 = X_100_input.num_cars;

figure()

max_scale_density_nominal = 0.065;
max_scale_density_param = 0.065;
for t_iter = t_start:t_stop
    t_iter = 3*t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    subplot(2, 2, [1, 2])
    cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
    hbl_density_nominal = heatmap(cars_on_road);
    hbl_density_nominal.GridVisible = 'off';
    hbl_density_nominal.Colormap = cool;
    hbl_density_nominal.CellLabelColor = 'none';
    hbl_density_nominal.XData = road_sectionX;
    hbl_density_nominal.YData = ['lane'];
    hbl_density_nominal.XLabel = 'Distance along the road section [m]';
    hbl_density_nominal.Title = 'Heat map of density of cars along 200 m road sections';
    caxis(hbl_density_nominal, [0, max_scale_density_nominal]); % fixing the color scheme so that it doesn't change. 

    subplot(2, 2, [3,4])

    cars_on_road = howmanycars(Xinputs, num_cars2, road_sectionX, t_iter, road_section_length)/road_section_length;
    hbl_density_input = heatmap(cars_on_road);
    hbl_density_input.GridVisible = 'off';
    hbl_density_input.Colormap = cool;
    hbl_density_input.CellLabelColor = 'none';
    hbl_density_input.XData = road_sectionX;
    hbl_density_input.YData = ['lane'];
    hbl_density_input.XLabel = 'Distance along the road section [m]';
    hbl_density_input.Title = 'Heat map of density of cars along 200 m road sections with change in input';
    caxis(hbl_density_input, [0, max_scale_density_param]); % fixing the color scheme so that it doesn't change. 
%     plot([3200, 3200, 3200], [0, 0.5, 1])
    

    drawnow
end



%% global T parameter hange. 
% X_global_T = load('response100_param_T_global.mat');
GlobalT_Xresponse = X_global_T.Xresponse;
GlobalT_numcars = X_global_T.num_cars;
Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;
times = [1, 30, 60, 120, 180];
query_road_sectionX = 0:100:6000;
timestep = 0.0001;
time_slice = times(1)/timestep;
congestion_data = howmanycars(GlobalT_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion per 200 m section [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(2)/timestep;
congestion_data = howmanycars(GlobalT_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]') 
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion per 200 m section [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(3)/timestep;
congestion_data = howmanycars(GlobalT_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(4)/timestep;
congestion_data = howmanycars(GlobalT_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion per 200 m section [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(5)/timestep;
congestion_data = howmanycars(GlobalT_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)

plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%  For V


paramv_Xresponse = X_100_V.Xresponse;
paramv_numcars = X_100_V.num_cars;
Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;
times = [1, 30, 60, 120, 180];
query_road_sectionX = 0:100:6000;
timestep = 0.1;
timestep_nominal = 0.0001;
time_slice = times(1)/timestep;
time_slice_nom = times(1)/timestep_nominal;
congestion_data = howmanycars(paramv_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice_nom, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion per 200 m section [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(2)/timestep;
time_slice_nom = times(2)/timestep_nominal;
congestion_data = howmanycars(paramv_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice_nom, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]') 
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion per 200 m section [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(3)/timestep;
time_slice_nom = times(3)/timestep_nominal;
congestion_data = howmanycars(paramv_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice_nom, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(4)/timestep;
time_slice_nom = times(4)/timestep_nominal;
congestion_data = howmanycars(paramv_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice_nom, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion per 200 m section [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)

%%
time_slice = times(5)/timestep;
time_slice_nom = times(5)/timestep_nominal;
congestion_data = howmanycars(paramv_Xresponse, GlobalT_numcars, road_sectionX, time_slice, road_section_length);
interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
nominal_cong_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice_nom, road_section_length);
nom_inter_cong_data = interp1(road_sectionX, nominal_cong_data, query_road_sectionX, 'spline');
hold on
subplot(2, 1, 1)
plot(query_road_sectionX, interpolated_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Increased T')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)
hold on
subplot(2, 1, 2)
plot(query_road_sectionX, nom_inter_cong_data)
ylim([0, 11]);
xlabel('Road sections [m]')
ylabel('Congestion [cars/m] ')
xlim([0 6000])
ylim([0 12])
title('Nominal')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
x0=380;
y0=20;
width=1200;
height=800;
set(gcf,'position',[x0,y0,width,height])
set(gca,'FontSize',15)



%% 
% X_100_V = load('response100V.mat');
% V100_Xresponse = X_100_V.Xresponse;
% V100_numcars = X_100_V.num_cars;
% times = [1, 30, 60, 120, 180];
% query_road_sectionX = 0:100:6000;
% 
% hold on
% time_slice = times(1)/timestep;
% congestion_data = howmanycars(V100_Xresponse, V100_numcars, road_sectionX, time_slice, road_section_length);
% interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
% plot(query_road_sectionX, interpolated_cong_data)
% ylim([0, 11]);
% xlabel('Road sections [m]')
% ylabel('Congestion per 200 m section [cars/m] ')
% xlim([0 6000])
% ylim([0 12])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% x0=380;
% y0=20;
% width=1200;
% height=800;
% set(gcf,'position',[x0,y0,width,height])
% set(gca,'FontSize',15)
% %%
% time_slice = times(2)/timestep;
% congestion_data = howmanycars(V100_Xresponse, V100_numcars, road_sectionX, time_slice, road_section_length);
% interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
% plot(query_road_sectionX, interpolated_cong_data)
% ylim([0, 11]);
% xlabel('Road sections [m]')
% ylabel('Congestion per 200 m section [cars/m] ')
% xlim([0 6000])
% ylim([0 12])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% set(gca,'FontSize',15)
% %%
% time_slice = times(3)/timestep;
% congestion_data = howmanycars(V100_Xresponse, V100_numcars, road_sectionX, time_slice, road_section_length);
% interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
% plot(query_road_sectionX, interpolated_cong_data)
% ylim([0, 11]);
% xlabel('Road sections [ m]')
% ylabel('Congestion per 200 m section [cars/m] ')
% xlim([0 6000])
% ylim([0 12])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% set(gca,'FontSize',15)
% 
% %%
% time_slice = times(4)/timestep;
% congestion_data = howmanycars(V100_Xresponse, V100_numcars, road_sectionX, time_slice, road_section_length);
% interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
% plot(query_road_sectionX, interpolated_cong_data)
% ylim([0, 11]);
% xlabel('Road sections [m]')
% ylabel('Congestion per 200 m section [cars/m] ')
% xlim([0 6000])
% ylim([0 12])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% set(gca,'FontSize',15)
% %%
% time_slice = times(5)/timestep;
% congestion_data = howmanycars(V100_Xresponse, V100_numcars, road_sectionX, time_slice, road_section_length);
% interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
% plot(query_road_sectionX, interpolated_cong_data)
% ylim([0, 11]);
% xlabel('Road sections [m]')
% ylabel('Congestion per 200 m section [cars/m] ')
% xlim([0 6000])
% ylim([0 12])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% set(gca,'FontSize',15)




% hold on
% for i = 1:size(times, 2)
%     time_slice = times(i)/timestep;
%     congestion_data = howmanycars(V100_Xresponse, V100_numcars, road_sectionX, time_slice, road_section_length);
%     interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
%     plot(query_road_sectionX, interpolated_cong_data)
%     ylim([0, 11]);
% end
% hold off
% xlabel('Road sections [m]')
% ylabel('Congestion per 200 m section [cars/m] ')
% xlim([0 6000])
% ylim([0 12])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% set(gca,'FontSize',15)








%
% %% First DEMo 100 cars  number of cars and velocity side by side.
% % flow and density should be on the right hand side. 
% Xresponse = X_100_nominal.Xresponse;
% num_cars = X_100_nominal.num_cars;
% 
% figure()
% 
% max_scale_cong = 13;
% max_scale_velc = max(max(Xresponse(num_cars+1:end, :)));
% for t_iter = t_start:t_stop
%     t_iter = t_iter/timestep;
%     if t_iter == 0
%         t_iter = 1;
%     end
%     subplot(1, 2, 1)
%     cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
%     hbl_congestion = heatmap(cars_on_road);
%     hbl_congestion.GridVisible = 'off';
%     hbl_congestion.Colormap = cool;
%     hbl_congestion.CellLabelColor = 'none';
%     hbl_congestion.XData = road_sectionX;
%     hbl_congestion.YData = ['lane'];
%     hbl_congestion.XLabel = 'Distance along the road section [m]';
%     hbl_congestion.Title = 'Heat map of number of cars along 200 m road sections';
%     caxis(hbl_congestion, [0, max_scale_cong]); % fixing the color scheme so that it doesn't change. 
% 
%     subplot(1, 2, 2)
%     cars_on_road = velocityheatmap(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
%     hbl_velc = heatmap(cars_on_road);
%     hbl_velc.GridVisible = 'off';
%     hbl_velc.Colormap = cool;
%     hbl_velc.CellLabelColor = 'none';
%     hbl_velc.XData = road_sectionX;
%     hbl_velc.YData = ['lane'];
%     hbl_velc.XLabel = 'Distance along the road section [m]';
%     hbl_velc.Title = 'Heatmap of velocity of cars along 200 m road sections';
%     caxis(hbl_velc, [0, max_scale_velc]); % fixing the color scheme so that it doesn't change. 
%     drawnow
% end






% 
% %% Second DEMO 100 cars density and flow side by side.
% Xresponse = X_100_nominal.Xresponse;
% num_cars = X_100_nominal.num_cars;
% 
% 
% figure()
% 
% max_scale_density = 0.065;
% max_scale_flow = 0.65;
% for t_iter = t_start:t_stop
%     t_iter = t_iter/timestep;
%     if t_iter == 0
%         t_iter = 1;
%     end
%     subplot(1, 2, 1)
%     cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
%     hbl_density = heatmap(cars_on_road);
%     hbl_density.GridVisible = 'off';
%     hbl_density.Colormap = cool;
%     hbl_density.CellLabelColor = 'none';
%     hbl_density.XData = road_sectionX;
%     hbl_density.YData = ['lane'];
%     hbl_density.XLabel = 'Distance along the road section [m]';
%     hbl_density.Title = 'Heat map of density of cars along 200 m road sections';
%     caxis(hbl_density, [0, max_scale_density]); % fixing the color scheme so that it doesn't change. 
% 
%     subplot(1, 2, 2)
%     veloc_on_road = velocityheatmap(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
%     flow_cars = cars_on_road.*veloc_on_road;
%     hbl_flow = heatmap(flow_cars);
%     hbl_flow.GridVisible = 'off';
%     hbl_flow.Colormap = cool;
%     hbl_flow.CellLabelColor = 'none';
%     hbl_flow.XData = road_sectionX;
%     hbl_flow.YData = ['lane'];
%     hbl_flow.XLabel = 'Distance along the road section [m]';
%     hbl_flow.Title = 'Heatmap of flow of cars along 200 m road sections';
%     caxis(hbl_flow, [0, max_scale_flow]); % fixing the color scheme so that it doesn't change. 
%     drawnow
% end
% 
% %% Third DEMO for the different parameters. Density heatmaps for different T
% 
% Xresponse = X_100_nominal.Xresponse;
% num_cars = X_100_nominal.num_cars;
% Xparam = X_100_global_T.Xresponse;
% num_cars2 = X_100_global_T.num_cars;
% 
% figure()
% 
% max_scale_density_nominal = 0.065;
% max_scale_density_param = 0.065;
% for t_iter = t_start:t_stop
%     t_iter = t_iter/timestep;
%     if t_iter == 0
%         t_iter = 1;
%     end
%     subplot(1, 2, 1)
%     cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
%     hbl_density_nominal = heatmap(cars_on_road);
%     hbl_density_nominal.GridVisible = 'off';
%     hbl_density_nominal.Colormap = cool;
%     hbl_density_nominal.CellLabelColor = 'none';
%     hbl_density_nominal.XData = road_sectionX;
%     hbl_density_nominal.YData = ['lane'];
%     hbl_density_nominal.XLabel = 'Distance along the road section [m]';
%     hbl_density_nominal.Title = 'Heat map of density of cars along 200 m road sections with T = 1.6';
%     caxis(hbl_density_nominal, [0, max_scale_density_nominal]); % fixing the color scheme so that it doesn't change. 
% 
%     subplot(1, 2, 2)
%     cars_on_road = howmanycars(Xparam, num_cars2, road_sectionX, t_iter, road_section_length)/road_section_length;
%     hbl_density_param = heatmap(cars_on_road);
%     hbl_density_param.GridVisible = 'off';
%     hbl_density_param.Colormap = cool;
%     hbl_density_param.CellLabelColor = 'none';
%     hbl_density_param.XData = road_sectionX;
%     hbl_density_param.YData = ['lane'];
%     hbl_density_param.XLabel = 'Distance along the road section [m]';
%     hbl_density_param.Title = 'Heat map of density of cars along 200 m road sections with T = 4';
%     caxis(hbl_density_param, [0, max_scale_density_param]); % fixing the color scheme so that it doesn't change. 
%     drawnow
% end
% 
% %% Fourth DEMO for different inputs, sudden stop. density
% 
% Xresponse = X_100_nominal.Xresponse;
% num_cars = X_100_nominal.num_cars;
% Xinputs = X_100_input.Xresponse;
% num_cars2 = X_100_input.num_cars;
% 
% figure()
% 
% max_scale_density_nominal = 0.065;
% max_scale_density_param = 0.065;
% for t_iter = t_start:t_stop
%     t_iter = 2*t_iter/timestep;
%     if t_iter == 0
%         t_iter = 1;
%     end
%     subplot(2, 2, [1, 2])
%     cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
%     hbl_density_nominal = heatmap(cars_on_road);
%     hbl_density_nominal.GridVisible = 'off';
%     hbl_density_nominal.Colormap = cool;
%     hbl_density_nominal.CellLabelColor = 'none';
%     hbl_density_nominal.XData = road_sectionX;
%     hbl_density_nominal.YData = ['lane'];
%     hbl_density_nominal.XLabel = 'Distance along the road section [m]';
%     hbl_density_nominal.Title = 'Heat map of density of cars along 200 m road sections';
%     caxis(hbl_density_nominal, [0, max_scale_density_nominal]); % fixing the color scheme so that it doesn't change. 
% 
%     subplot(2, 2, [3,4])
% 
%     cars_on_road = howmanycars(Xinputs, num_cars2, road_sectionX, t_iter, road_section_length)/road_section_length;
%     hbl_density_input = heatmap(cars_on_road);
%     hbl_density_input.GridVisible = 'off';
%     hbl_density_input.Colormap = cool;
%     hbl_density_input.CellLabelColor = 'none';
%     hbl_density_input.XData = road_sectionX;
%     hbl_density_input.YData = ['lane'];
%     hbl_density_input.XLabel = 'Distance along the road section [m]';
%     hbl_density_input.Title = 'Heat map of density of cars along 200 m road sections with change in input';
%     caxis(hbl_density_input, [0, max_scale_density_param]); % fixing the color scheme so that it doesn't change. 
% %     plot([3200, 3200, 3200], [0, 0.5, 1])
%     
% 
%     drawnow
% end
% 
% 
% %% Fifth DEMO for different inputs, sudden stop. flow -- not sure if this is needed. 
% 
% Xresponse = X_100_nominal.Xresponse;
% num_cars = X_100_nominal.num_cars;
% Xinputs = X_100_input.Xresponse;
% num_cars2 = X_100_input.num_cars;
% 
% figure()
% 
% max_scale_flow = 0.65;
% max_scale_flow_input = 0.65;
% for t_iter = t_start:t_stop
%     t_iter = t_iter/timestep;
%     if t_iter == 0
%         t_iter = 1;
%     end
%     subplot(1, 2, 1)
%     cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
%     veloc_on_road = velocityheatmap(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
%     flow_cars = cars_on_road.*veloc_on_road;
%     hbl_flow = heatmap(flow_cars);
%     hbl_flow.GridVisible = 'off';
%     hbl_flow.Colormap = cool;
%     hbl_flow.CellLabelColor = 'none';
%     hbl_flow.XData = road_sectionX;
%     hbl_flow.YData = ['lane'];
%     hbl_flow.XLabel = 'Distance along the road section [m]';
%     hbl_flow.Title = 'Heatmap of flow of cars along 200 m road sections';
%     caxis(hbl_flow, [0, max_scale_flow]); % fixing the color scheme so that it doesn't change.  
% 
%     subplot(1, 2, 2)
%     cars_on_road_input = howmanycars(Xinputs, num_cars2, road_sectionX, t_iter, road_section_length)/road_section_length;
%     veloc_on_road_input = velocityheatmap(Xinputs, num_cars2, road_sectionX, t_iter, road_section_length);
%     flow_cars_input = cars_on_road_input.*veloc_on_road_input;
%     hbl_flow_input = heatmap(flow_cars_input);
%     hbl_flow_input.GridVisible = 'off';
%     hbl_flow_input.Colormap = cool;
%     hbl_flow_input.CellLabelColor = 'none';
%     hbl_flow_input.XData = road_sectionX;
%     hbl_flow_input.YData = ['lane'];
%     hbl_flow_input.XLabel = 'Distance along the road section [m]';
%     hbl_flow_input.Title = 'Heatmap of flow of cars along 200 m road sections with changed input';
%     caxis(hbl_flow_input, [0, max_scale_flow_input]); % fixing the color scheme so that it doesn't change.  
% 
%     drawnow
% end
% 



