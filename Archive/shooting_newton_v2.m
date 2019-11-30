function [F, J] = shooting_newton_v2(x0,T,p,timestep)

epsilon = 0.1;
x_orig = ForwardEuler('human_car_behaviour_v5',x0,p,'sinusoidal_input',0,T,timestep,false);
x_orig = x_orig(:,end);
F = x_orig - x0;

J = zeros(2,2);

x_perturb1 = ForwardEuler('human_car_behaviour_v5',x0 + epsilon*[1;0],p,'sinusoidal_input',0,T,timestep,false);
x_perturb2 = ForwardEuler('human_car_behaviour_v5',x0 + epsilon*[0;1],p,'sinusoidal_input',0,T,timestep,false);

x_perturb1 = x_perturb1(:,end);
x_perturb2 = x_perturb2(:,end);

J(1,1) = (x_perturb1(1) - x_orig(1))/epsilon;
J(1,2) = (x_perturb2(1) - x_orig(1))/epsilon;
J(2,1) = (x_perturb1(2) - x_orig(2))/epsilon;
J(2,2) = (x_perturb2(2) - x_orig(2))/epsilon;
J = J - eye(2);

end