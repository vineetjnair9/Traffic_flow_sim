% Example on the use of bodePlot

% A matrix for 1st system
A1 = [
-1	0
0	-10
];

% A matrix for 2nd system
A2 = [
-4	0
0	-10
];

% b and c for both systems
b = [-100 141].';
c = [-0.1 -0.144];

% Construct systems with ss
sys1 = ss(A1,b,c,0);
sys2 = ss(A2,b,c,0);

% Log-spaced frequency vector
freq = logspace(-3,2,100);

% Bode plot
bodePlot(freq,sys1,sys2);

% Step response
figure
step(sys1,sys2)
