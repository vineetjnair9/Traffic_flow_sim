clc; clear all; close all;
disp('testing state space model with nonlinear (i.e. squared diagonal) vector field')
disp('showing time domain simulation')
test_SquaredDiagonalExample;
disp('press any key for the next test')
pause

clc; clear all; close all;
disp('testing 1D linear diffusion on a heat conducting bar')
disp('showing time domain simulation')
test_HeatBarExample;
disp('press any key for the next test')
pause

clc; clear all; close all;
disp('testing Finite Difference Jacobian function')
disp('showing difference from analytical jacobian when using different perturbations')
test_FiniteDifferenceJacobian;
disp('press any key for the next test')
pause

clc; clear all; close all;
disp('testing Newton solver function')
disp('showing iterations of polynomial roots finder')
test_NewtonPoly;
disp('press any key for the next test')
pause

clc; clear all; close all;
disp('testing Newton solver function')
disp('showing iterations of state toward steady state of squared diagonal nonlinear system')
test_NewtonSquaredDiagonal;
disp('press any key for the next test')
pause

clc; clear all; close all;
disp('testing Implicit time domain integration function')
disp('showing Backward Euler on squared diagonal nonlinear system')
test_ImplicitSquaredDiagonal
disp('press any key for the next test')
pause

clc; clear all; close all;
disp('testing Implicit time domain integration function')
disp('showing Backward Euler on linear 1-D heat diffusion bar')
test_ImplicitHeatBar;


