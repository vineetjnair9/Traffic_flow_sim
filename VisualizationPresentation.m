%% loading data. 
load response.mat

%% setting up the road section and the disretization of the road section 
road_section_length = 200;
road_sectionX = 0:road_section_length:1800;  % create a road section along the x-axis.
%%
% For congestion.
max_scale_cong = num_cars*3/4;
for t_iter = t_start:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    
    cars_on_road = howmanycars(X, num_cars, road_sectionX, t_iter, road_section_length);
    hbl_congestion = heatmap(cars_on_road);
    hbl_congestion.GridVisible = 'off';
    hbl_congestion.Colormap = cool;
    hbl_congestion.CellLabelColor = 'none';
    hbl_congestion.XData = road_sectionX;
    hbl_congestion.YData = ['lane'];
    hbl_congestion.XLabel = 'Distance along the road section [m]';
    caxis(hbl_congestion, [0, max_scale_cong]); % fixing the color scheme so that it doesn't change. 

    
    drawnow
end

    
%% For velocity heatmaps

% avg_velc = velocityheatmap(X, num_cars, road_sectionX, 5);
max_scale_velc = max(max(X(num_cars+1:end, :)));
for t_iter = t_start:0.5:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    
    cars_on_road = velocityheatmap(X, num_cars, road_sectionX, t_iter, road_section_length);
    hbl_velc = heatmap(cars_on_road);
    hbl_velc.GridVisible = 'off';
    hbl_velc.Colormap = cool;
    hbl_velc.CellLabelColor = 'none';
    hbl_velc.XData = road_sectionX;
    hbl_velc.YData = ['lane'];
    hbl_velc.XLabel = 'Distance along the road section [m]';
    caxis(hbl_velc, [0, max_scale_velc]); % fixing the color scheme so that it doesn't change. 
    drawnow;
end

%% do side by side

figure()
subplot(1, 2, 1)
max_scale_cong = num_cars*3/4;
for t_iter = t_start:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    
    cars_on_road = howmanycars(X, num_cars, road_sectionX, t_iter, road_section_length);
    hbl_congestion = heatmap(cars_on_road);
    hbl_congestion.GridVisible = 'off';
    hbl_congestion.Colormap = cool;
    hbl_congestion.CellLabelColor = 'none';
    hbl_congestion.XData = road_sectionX;
    hbl_congestion.YData = ['lane'];
    hbl_congestion.XLabel = 'Distance along the road section [m]';
    caxis(hbl_congestion, [0, max_scale_cong]); % fixing the color scheme so that it doesn't change. 

    
    drawnow
end

subplot(1, 2, 2)
max_scale_velc = max(max(X(num_cars+1:end, :)));
for t_iter = t_start:0.5:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    
    cars_on_road = velocityheatmap(X, num_cars, road_sectionX, t_iter, road_section_length);
    hbl_velc = heatmap(cars_on_road);
    hbl_velc.GridVisible = 'off';
    hbl_velc.Colormap = cool;
    hbl_velc.CellLabelColor = 'none';
    hbl_velc.XData = road_sectionX;
    hbl_velc.YData = ['lane'];
    hbl_velc.XLabel = 'Distance along the road section [m]';
    caxis(hbl_velc, [0, max_scale_velc]); % fixing the color scheme so that it doesn't change. 
    drawnow;
end






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
times = [1, 30, 60];
road_section_length = 100;
road_sectionX = 0:road_section_length:1800;  % create a road section along the x-axis.

hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    avg_velc_data = velocityheatmap(X, num_cars, road_sectionX, time_slice, road_section_length);
    plot(road_sectionX, avg_velc_data, 'o-')
end
hold off
legend

%% plots for flux
times = [1, 30, 60, 90, 120];
road_section_length = 100;
road_sectionX = 0:road_section_length:1800;  % create a road section along the x-axis.

hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    avg_velc_data = velocityheatmap(X,num_cars, road_sectionX, time_slice, road_section_length);
    congestion_data = howmanycars(X, num_cars, road_sectionX, time_slice, road_section_length)/road_section_length;
    flux_data = congestion_data.*avg_velc_data;
    plot(road_sectionX, flux_data, 'o-')
end
hold off
legend


%% plots for densities
times = [1, 10, 20, 30, 40, 50, 60];
hold on
for i = 1:size(times, 2)
    time_slice = times(i)/timestep;
    congestion_data = howmanycars(X, num_cars, road_sectionX, time_slice, road_section_length)/road_section_length;
    plot(road_sectionX, congestion_data, 'o-')
    % work on adding legends
end
hold off


