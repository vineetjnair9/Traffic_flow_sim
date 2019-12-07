%% loading data. 
X_100_nominal = load('response100.mat');
%%
X_100_global_T = load('response100_param_T_global.mat');
%%
X_100_input = load('response100_varied_input.mat');
% num_cars = 100;
%% setting up the road section and the disretization of the road section 
% road_section_length = 500; % for the 500 cars. 
% road_sectionX = 0:road_section_length:14000;  % create a road section along the x-axis.

road_section_length = 200;
road_sectionX = 0:road_section_length:6000; % for the others
t_start = 0;
t_stop = 180;
timestep = 1E-4;

%% First DEMo 100 cars  number of cars and velocity side by side.
% flow and density should be on the right hand side. 
Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;


figure()

max_scale_cong = 13;
max_scale_velc = max(max(Xresponse(num_cars+1:end, :)));
for t_iter = t_start:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    subplot(1, 2, 1)
    cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
    hbl_congestion = heatmap(cars_on_road);
    hbl_congestion.GridVisible = 'off';
    hbl_congestion.Colormap = cool;
    hbl_congestion.CellLabelColor = 'none';
    hbl_congestion.XData = road_sectionX;
    hbl_congestion.YData = ['lane'];
    hbl_congestion.XLabel = 'Distance along the road section [m]';
    hbl_congestion.Title = 'Heat map of number of cars along 200 m road sections';
    caxis(hbl_congestion, [0, max_scale_cong]); % fixing the color scheme so that it doesn't change. 

    subplot(1, 2, 2)
    cars_on_road = velocityheatmap(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
    hbl_velc = heatmap(cars_on_road);
    hbl_velc.GridVisible = 'off';
    hbl_velc.Colormap = cool;
    hbl_velc.CellLabelColor = 'none';
    hbl_velc.XData = road_sectionX;
    hbl_velc.YData = ['lane'];
    hbl_velc.XLabel = 'Distance along the road section [m]';
    hbl_velc.Title = 'Heatmap of velocity of cars along 200 m road sections';
    caxis(hbl_velc, [0, max_scale_velc]); % fixing the color scheme so that it doesn't change. 
    drawnow
end


%% Second DEMO 100 cars density and flow side by side.
Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;


figure()

max_scale_density = 0.065;
max_scale_flow = 0.65;
for t_iter = t_start:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    subplot(1, 2, 1)
    cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
    hbl_density = heatmap(cars_on_road);
    hbl_density.GridVisible = 'off';
    hbl_density.Colormap = cool;
    hbl_density.CellLabelColor = 'none';
    hbl_density.XData = road_sectionX;
    hbl_density.YData = ['lane'];
    hbl_density.XLabel = 'Distance along the road section [m]';
    hbl_density.Title = 'Heat map of density of cars along 200 m road sections';
    caxis(hbl_density, [0, max_scale_density]); % fixing the color scheme so that it doesn't change. 

    subplot(1, 2, 2)
    veloc_on_road = velocityheatmap(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
    flow_cars = cars_on_road.*veloc_on_road;
    hbl_flow = heatmap(flow_cars);
    hbl_flow.GridVisible = 'off';
    hbl_flow.Colormap = cool;
    hbl_flow.CellLabelColor = 'none';
    hbl_flow.XData = road_sectionX;
    hbl_flow.YData = ['lane'];
    hbl_flow.XLabel = 'Distance along the road section [m]';
    hbl_flow.Title = 'Heatmap of flow of cars along 200 m road sections';
    caxis(hbl_flow, [0, max_scale_flow]); % fixing the color scheme so that it doesn't change. 
    drawnow
end

%% Third DEMO for the different parameters. Density heatmaps for different T

Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;
Xparam = X_100_global_T.Xresponse;
num_cars2 = X_100_global_T.num_cars;

figure()

max_scale_density_nominal = 0.065;
max_scale_density_param = 0.065;
for t_iter = t_start:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    subplot(1, 2, 1)
    cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
    hbl_density_nominal = heatmap(cars_on_road);
    hbl_density_nominal.GridVisible = 'off';
    hbl_density_nominal.Colormap = cool;
    hbl_density_nominal.CellLabelColor = 'none';
    hbl_density_nominal.XData = road_sectionX;
    hbl_density_nominal.YData = ['lane'];
    hbl_density_nominal.XLabel = 'Distance along the road section [m]';
    hbl_density_nominal.Title = 'Heat map of density of cars along 200 m road sections with T = 1.6';
    caxis(hbl_density_nominal, [0, max_scale_density_nominal]); % fixing the color scheme so that it doesn't change. 

    subplot(1, 2, 2)
    cars_on_road = howmanycars(Xparam, num_cars2, road_sectionX, t_iter, road_section_length)/road_section_length;
    hbl_density_param = heatmap(cars_on_road);
    hbl_density_param.GridVisible = 'off';
    hbl_density_param.Colormap = cool;
    hbl_density_param.CellLabelColor = 'none';
    hbl_density_param.XData = road_sectionX;
    hbl_density_param.YData = ['lane'];
    hbl_density_param.XLabel = 'Distance along the road section [m]';
    hbl_density_param.Title = 'Heat map of density of cars along 200 m road sections with T = 4';
    caxis(hbl_density_param, [0, max_scale_density_param]); % fixing the color scheme so that it doesn't change. 
    drawnow
end

%% Fourth DEMO for different inputs, sudden stop. density

Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;
Xinputs = X_100_input.Xresponse;
num_cars2 = X_100_input.num_cars;

figure()

max_scale_density_nominal = 0.065;
max_scale_density_param = 0.065;
for t_iter = t_start:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    subplot(1, 2, 1)
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

    subplot(1, 2, 2)
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

    drawnow
end

%% Fifth DEMO for different inputs, sudden stop. flow -- not sure if this is needed. 

Xresponse = X_100_nominal.Xresponse;
num_cars = X_100_nominal.num_cars;
Xinputs = X_100_input.Xresponse;
num_cars2 = X_100_input.num_cars;

figure()

max_scale_flow = 0.65;
max_scale_flow_input = 0.65;
for t_iter = t_start:t_stop
    t_iter = t_iter/timestep;
    if t_iter == 0
        t_iter = 1;
    end
    subplot(1, 2, 1)
    cars_on_road = howmanycars(Xresponse, num_cars, road_sectionX, t_iter, road_section_length)/road_section_length;
    veloc_on_road = velocityheatmap(Xresponse, num_cars, road_sectionX, t_iter, road_section_length);
    flow_cars = cars_on_road.*veloc_on_road;
    hbl_flow = heatmap(flow_cars);
    hbl_flow.GridVisible = 'off';
    hbl_flow.Colormap = cool;
    hbl_flow.CellLabelColor = 'none';
    hbl_flow.XData = road_sectionX;
    hbl_flow.YData = ['lane'];
    hbl_flow.XLabel = 'Distance along the road section [m]';
    hbl_flow.Title = 'Heatmap of flow of cars along 200 m road sections';
    caxis(hbl_flow, [0, max_scale_flow]); % fixing the color scheme so that it doesn't change.  

    subplot(1, 2, 2)
    cars_on_road_input = howmanycars(Xinputs, num_cars2, road_sectionX, t_iter, road_section_length)/road_section_length;
    veloc_on_road_input = velocityheatmap(Xinputs, num_cars2, road_sectionX, t_iter, road_section_length);
    flow_cars_input = cars_on_road_input.*veloc_on_road_input;
    hbl_flow_input = heatmap(flow_cars_input);
    hbl_flow_input.GridVisible = 'off';
    hbl_flow_input.Colormap = cool;
    hbl_flow_input.CellLabelColor = 'none';
    hbl_flow_input.XData = road_sectionX;
    hbl_flow_input.YData = ['lane'];
    hbl_flow_input.XLabel = 'Distance along the road section [m]';
    hbl_flow_input.Title = 'Heatmap of flow of cars along 200 m road sections with changed input';
    caxis(hbl_flow_input, [0, max_scale_flow_input]); % fixing the color scheme so that it doesn't change.  

    drawnow
end

%% heat map snapshots.
X500full = load('response500full.mat');
%% using custom heatmap
% t = 120;
% timestep = 1E-4;
% X500 = X500full.Xresponse;
% num_cars= X500full.num_cars;
% figure(1)
% cars_on_road = howmanycars(X500, num_cars, road_sectionX, t/timestep, road_section_length)/road_section_length;
% veloc_on_road = velocityheatmap(X500, num_cars, road_sectionX, t/timestep, road_section_length);
% 
% flow_cars = cars_on_road.*veloc_on_road;
% hbl_flow = heatmap_custom(flow_cars, 0:1000:6000);
% % hbl_flow.GridVisible = 'off';
% % hbl_flow.Colormap = cool;
% % hbl_flow.CellLabelColor = 'none';
% % hbl_flow.XData = road_sectionX;
% % hbl_flow.YData = ['lane'];
% % hbl_flow.XLabel = 'Distance along the road section [m]';
% % hbl_flow.Title = 'Heatmap of flow of cars along 200 m road sections at t = 120 s';
% set(gca, 'FontSize', 15);
% 
% % figure(2)
% % cars_on_road = howmanycars(X500, num_cars, road_sectionX, t/timestep, road_section_length)/road_section_length;
% % hbl_density_input = heatmap(cars_on_road);
% % hbl_density_input.GridVisible = 'off';
% % hbl_density_input.Colormap = cool;
% % hbl_density_input.CellLabelColor = 'none';
% % hbl_density_input.XData = road_sectionX;
% % hbl_density_input.XDisplayData = 0:400:6000;
% % hbl_density_input.YData = ['lane'];
% % hbl_density_input.XLabel = 'Distance along the road section [m]';
% % hbl_density_input.Title = 'Heat map of density along 200 m road sections at t = 120 s';
% % set(gca,'FontSize',15);
% 

%%
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







