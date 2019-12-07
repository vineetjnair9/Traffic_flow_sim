% Generating plots
%% loading data. 
load response100_varied_input.mat
timestep = 1E-4;
%%
road_section_length = 200;
road_sectionX = 0:road_section_length:6000; % for the others
query_road_sectionX = 0:100:6000;

%%   plots, not heatmaps   congestion

times = [1, 10, 20, 30, 40, 50, 60];
% figure(1)
% hold on
% for i = 1:size(times, 2)
%     time_slice = times(i)/timestep;
%     congestion_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
% %     interpolated_cong_data = interp1(road_sectionX, congestion_data);
%     plot(road_sectionX, congestion_data)
%     % work on adding legends
% end
% hold off
% xlabel('Road sections [m]')
% ylabel('Congestion per 200 m section [cars/m]')
% xlim([0 6500])
% ylim([0 12])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% set(gca,'FontSize',15)
% figure(2)
hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    congestion_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
    interpolated_cong_data = interp1(road_sectionX, congestion_data, query_road_sectionX, 'spline');
    plot(query_road_sectionX, interpolated_cong_data)
    ylim([0, 11]);
end
hold off
xlabel('Road sections [m]')
ylabel('Congestion per 200 m section [cars/m] ')
xlim([0 6000])
ylim([0 12])
legend('0 s', '30 s', '60 s', '120 s', '180 s')
set(gca,'FontSize',15)

%% plots, not heatmaps for avg. velocities
% times = [1, 10, 20, 30, 40, 50, 60];
times = [1, 30, 60, 120, 180];

hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    avg_velc_data = velocityheatmap(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
    interpolated_velc = interp1(road_sectionX, avg_velc_data, query_road_sectionX, 'spline');
    plot(query_road_sectionX, interpolated_velc, 'LineWidth', 1.2)
end
hold off
xlabel('Road sections [m]')
ylabel('Avg. velocity per 200 m section [m/s]')
legend('0 s', '30 s', '60 s', '120 s', '180 s')
set(gca,'FontSize',15)

%% plots for flow
times = [1, 30, 60, 120, 180];

hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    avg_velc_data = velocityheatmap(Xresponse,num_cars, road_sectionX, time_slice, road_section_length);
    congestion_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length)/road_section_length;
    flux_data = congestion_data.*avg_velc_data;
    interpolated_flux_data = interp1(road_sectionX, flux_data, query_road_sectionX, 'spline');
    plot(query_road_sectionX, interpolated_flux_data, 'LineWidth', 1.2)
end
hold off
xlabel('Road sections [m]')
ylabel('Flow per 200 m section [cars/s]')
xlim([0 6000])
ylim([0 1.1])
legend('0 s', '30 s', '60 s', '120 s', '180 s')
set(gca,'FontSize',15)


%% plots for densities
times = [1, 30, 60, 120, 180];
% figure(1)
% hold on
% for i = 1:size(times, 2)
%     time_slice = times(i)/timestep;
%     congestion_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length)/road_section_length;
%     plot(road_sectionX, congestion_data, 'LineWidth', 1.2)
% end
% hold off
% xlabel('Road sections [m]')
% ylabel('Density per 200 m section [cars/m]')
% xlim([0 6500])
% ylim([0 0.06])
% legend('0 s', '30 s', '60 s', '120 s', '180 s')
% set(gca,'FontSize',15)
% 
% figure(2)
hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    congestion_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length)/road_section_length;
    interpolated_density_data = interp1(road_sectionX, congestion_data, 0:100:6000, 'spline');
    plot(0:100:6000, interpolated_density_data, 'LineWidth', 1.2)
end
hold off
xlabel('Road sections [m]')
ylabel('Density per 200 m section [cars/m]')
xlim([0 6000])
ylim([0 0.12])
legend('0 s', '30 s', '60 s', '120 s', '180 s')
set(gca,'FontSize',15)

%% normal plots
timestep = 0.0001;
t = t_start:timestep:t_stop; 

figure(1)  
hold on
for i = 1:num_cars
    plot(t,Xresponse(i,:));
end
xlabel('Time [s]');
ylabel('Position along road [m]');
hold off
legend('car 1', 'car 2', 'car 3', 'car 4', 'car 5')
set(gca,'FontSize',15)
xlim([0, 180])
ylim([0, 4000])



figure(2)  
hold on
for i = num_cars+1:2*num_cars
    plot(t,Xresponse(i,:));
end
xlabel('Time [s]'); 
ylabel('Speed of car [m/s]');
hold off
legend('car 1', 'car 2', 'car 3', 'car 4', 'car 5')
set(gca,'FontSize',15)
xlim([0, 180])
ylim([13, 24])


%% heat map snapshots.
X500full = load('response500full.mat');

t = 120;
X500 = X500full.Xresponse;
num_cars = X500full.num_cars;
timestep = 1E-4;

%congestion
% figure(1)
% cars_on_road = howmanycars(X500, num_cars, road_sectionX, t/timestep, road_section_length);
% hbl_congestion = heatmap(cars_on_road);
% hbl_congestion.GridVisible = 'off';
% hbl_congestion.Colormap = cool;
% hbl_congestion.CellLabelColor = 'none';
% hbl_congestion.XData = road_sectionX;
% hbl_congestion.YData = ['lane'];
% hbl_congestion.XLabel = 'Distance along the road section [m]';
% hbl_congestion.Title = 'Heat map of number of cars along 200 m road sections at t = 120 s';
% set(gca,'FontSize',15);
% density

figure(2)
cars_on_road = howmanycars(X500, num_cars, road_sectionX, t/timestep, road_section_length)/road_section_length;
hbl_density_input = heatmap(cars_on_road);
hbl_density_input.GridVisible = 'off';
hbl_density_input.Colormap = cool;
hbl_density_input.CellLabelColor = 'none';
hbl_density_input.XData = road_sectionX; 
hbl_density_input.YData = ['lane'];
hbl_density_input.XLabel = 'Distance along the road section [m]';
hbl_density_input.Title = 'Density along 200 m road sections at t = 120 s';
set(gca,'FontSize',15);
hbl_density_input.XDisplayLabels = {'0', ' ', ' ', ' ', ' ','1000', ' ', ' ', ' ', ' ','2000', ' ', ' ', ' ', ' ','3000', ' ', ' ', ' ', ' ','4000', ' ', ' ', ' ', ' ','5000', ' ', ' ', ' ', ' ','6000'};
% set(gca,'XTick',0:1000:6000)

% velocity
% figure(3)
veloc_on_road = velocityheatmap(X500, num_cars, road_sectionX, t/timestep, road_section_length);
% hbl_velc = heatmap(veloc_on_road);
% hbl_velc.GridVisible = 'off';
% hbl_velc.Colormap = cool;
% hbl_velc.CellLabelColor = 'none';
% hbl_velc.XData = road_sectionX;
% hbl_velc.YData = ['lane'];
% hbl_velc.XLabel = 'Distance along the road section [m]';
% hbl_velc.Title = 'Heatmap of velocity of cars along 200 m road sections at t = 120 s';
% set(gca, 'FontSize', 15);

%flow
figure(4)
flow_cars = cars_on_road.*veloc_on_road;
hbl_flow = heatmap(flow_cars);
hbl_flow.GridVisible = 'off';
hbl_flow.Colormap = cool;
hbl_flow.CellLabelColor = 'none';
hbl_flow.XData = road_sectionX;
hbl_flow.YData = ['lane'];
hbl_flow.XLabel = 'Distance along the road section [m]';
hbl_flow.Title = 'Flow along 200 m road sections at t = 120 s';
hbl_flow.XDisplayLabels = {'0', ' ', ' ', ' ', ' ','1000', ' ', ' ', ' ', ' ','2000', ' ', ' ', ' ', ' ','3000', ' ', ' ', ' ', ' ','4000', ' ', ' ', ' ', ' ','5000', ' ', ' ', ' ', ' ','6000'};

set(gca, 'FontSize', 15);







