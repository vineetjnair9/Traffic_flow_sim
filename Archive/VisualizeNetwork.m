function VisualizeNetwork(NodeCoordinates,NodalValues,EdgeConnections,FlowValues,color,height);
%Visualizes a network using circles and edges
% 
% EXAMPLE 1
% clear all; close all
% NodeCoordinates = [0 0; 3 4; 0 7] 
% NodalValues     = [ 1;  0.5; 1.5] 
% EdgeConnections = [1 2; 2 3; 3 1]
% FlowValues      = [10;   3;  20]  
% color           = 'r';
% height          = 0.5;
% VisualizeNetwork(NodeCoordinates,NodalValues,EdgeConnections,FlowValues,height);
% axis equal
%
% EXAMPLE 2
% VisualizeNetwork([0 0; 3 4],[1; 0.5], [1 2],[10])

% Copyright Luca Daniel, MIT 2013

if ~exist('color','var')
   color = 'b';
end
if ~exist('height','var')
   height = 0;
end

hold on
points = 20;
for i = 1:size(NodalValues,1),
   center = [NodeCoordinates(i,1) NodeCoordinates(i,2)];
   radius = NodalValues(i);
   DrawCircle(center,radius,color,height,points);
end

clear i
for i = 1:size(FlowValues,1),
   nodeA = [NodeCoordinates(EdgeConnections(i,1),1) NodeCoordinates(EdgeConnections(i,1),2)];
   nodeB = [NodeCoordinates(EdgeConnections(i,2),1) NodeCoordinates(EdgeConnections(i,2),2)];
   thickness = FlowValues(i);
   DrawEdge(nodeA,nodeB,thickness,color,height);
end



%***************************************************
function DrawCircle(center,radius,color,height,points);
%Draws a circle
% 
% EXAMPLE 1
% center = [-3 7];
% radius = 4;
% color = 'r';
% height = 0;
% points = 20;
% DrawCircle(center, radius, color, height, points);
%
% EXAMPLE 2
% DrawCircle([-3 7], 4);
%
% Copyright Luca Daniel, MIT 2013

if ~exist('color','var')
   color = 'b';
end
if ~exist('height','var')
   height = 0;
end
if ~exist('points','var')
   points = 20;
end

t=0:2*pi/points:2*pi;
fill3(sin(t)*radius+center(1),cos(t)*radius+center(2),zeros(size(t))+height,color);


%*****************************************************
function DrawEdge(nodeA,nodeB,thickness,color,height);
%Draws an edge between two nodes 
% 
% EXAMPLE 1
% nodeA = [0 0 0];
% nodeB = [-3 7 0];
% color = 'r';
% thickness = 3;
% DrawEdge(nodeA,nodeB,thickness,color);
%
% EXAMPLE 2
% DrawEdge([0 0],[-3 7]);

% Copyright Luca Daniel, MIT 2013

if ~exist('color','var')
   color = 'b';
end
if ~exist('thickness','var')
   thickness = 3;
end
if ~exist('height','var')
   height = 0;
end

X = [nodeA(1) nodeB(1)];
Y = [nodeA(2) nodeB(2)];
Z = [height   height];

line(X,Y,Z, 'LineWidth', thickness, 'color', color);


