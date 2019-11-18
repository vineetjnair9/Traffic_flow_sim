%example script showing how to use VisualizeNetwork

%copyright Luca Daniel MIT 2013

clear all; close all; %allways start with these two

NodeCoordinates = [0 0; 3 4; 0 7] %you can make these up or get them from Amy's students
NodalValues     = [ 1;  0.5; 1.5] %this is the solution of your nodal analysis problem

EdgeConnections = [1 2; 2 3; 3 1] %you can derive this from your nodal matrix
FlowValues      = [6;   3;  10]  %you can compute this using the consitutite equations

VisualizeNetwork(NodeCoordinates,NodalValues,EdgeConnections,FlowValues);
axis equal %this makes circle look like circles rather than ovals
drawnow    %this is important if you are trying to do animations

return %remove this command if you want to see the action of the remaining of this script



%***********************************************************************
%note: later in the application period you may need to visualize
%multiple networks at the same time (e.g. electrical, gas, oil etc...)
%you can do this by using a different color and height for each network
%if you do not specify the color the dafault will be 'b' for blue
%if you do not specify the height the default will be 0
%here is an example of how to visualize a second network

NodeCoordinatesNetB = [0 7; 5 8; -3 13]; 
NodalValuesNetB     = [0.5;  1;   0.5];

EdgeConnectionsNetB = [1 2; 1 3];
FlowValuesNetB      = [4;   3]

color  = 'r';
height = 1;

VisualizeNetwork(NodeCoordinatesNetB,NodalValuesNetB,EdgeConnectionsNetB,FlowValuesNetB,color,height);
%view(30,40) %this allows a 3D view
