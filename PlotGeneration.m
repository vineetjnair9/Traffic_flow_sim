% Generating plots
%% loading data. 
load response1000selected.mat


%%   plots, not heatmaps   congestion

times = [1, 10, 20, 30, 40, 50, 60];
hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    congestion_data = howmanycars(X, num_cars, road_sectionX, time_slice, road_section_length);
    plot(road_sectionX, congestion_data, 'o-')
    % work on adding legends
end
hold off

%% plots, not heatmaps for avg. velocities
% times = [1, 10, 20, 30, 40, 50, 60];
times = [1, 30, 60, 120, 180];

hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    avg_velc_data = velocityheatmap(Xresponse, num_cars, road_sectionX, time_slice, road_section_length);
    plot(road_sectionX, avg_velc_data, 'LineWidth', 1.2)
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
    plot(road_sectionX, flux_data, 'LineWidth', 1.2)
end
hold off
xlabel('Road sections [m]')
ylabel('Flow per 200 m section [cars/s]')
xlim([0 6500])
ylim([0 1.1])
legend('0 s', '30 s', '60 s', '120 s', '180 s')
set(gca,'FontSize',15)


%% plots for densities
times = [1, 30, 60, 120, 180];
hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    congestion_data = howmanycars(Xresponse, num_cars, road_sectionX, time_slice, road_section_length)/road_section_length;
    plot(road_sectionX, congestion_data, 'LineWidth', 1.2)
end
hold off
xlabel('Road sections [m]')
ylabel('Density per 200 m section [cars/m]')
xlim([0 6500])
ylim([0 0.06])
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

figure(2)  
hold on
for i = num_cars+1:2*num_cars
    plot(t,Xresponse(i,:));
end
xlabel('Time [s]'); 
ylabel('Speed of car [m/s]');
hold off
