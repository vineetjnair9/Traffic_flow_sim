%example script showing how to use make animations with VisualizeNetwork

%copyright Luca Daniel MIT 2013

clear all; close all; %allways start with these two

NodeCoordinates = [0 0; 3 4; 0 7]; %you can make these up or get them from Amy's students
EdgeConnections = [1 2; 2 3; 3 1]; %you can derive this from your nodal matrix

%the values for your animations should really be computed using some integration
%algorithm on your network such as backward euler or trapezoidal
%here I am generating some fake signals just to illustrate how to visualize
%the behaviour of your network using VisualizeNetwork in an animation

N=50;
for t=0:2*pi/N:2*pi*4,
   clf;
   NodalValues = [ 1;  0.5; 1.5] * (0.4*cos(t)+1);  
   FlowValues  = [ 8;   5;  15]  * (0.4*sin(t)+1);   
   VisualizeNetwork(NodeCoordinates,NodalValues*(0.4*cos(t)+1.01),EdgeConnections,FlowValues*(0.4*sin(t)+1.01));
   axis equal
   axis([-4 5 -3 11]);
   drawnow
   for w=1:100000,      %this is just to introduce some delay if your computer is too fast
      tmp=log(35);
   end
end
