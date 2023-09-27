function [q] = DobotIk(x,y,z)
%DobotIk Custom Inverse Kinematics for the Dobot

% Solve for q1
q1 = atan2(y, x);

% Define functions for each equation
eq1 = @(q2, q3) (0.135*sin(q2) + 0.147*sin(q2 + q3) + 0.06) * cos(q1) - x;
eq2 = @(q2, q3) (0.135*sin(q2) + 0.147*sin(q2 + q3) + 0.06) * sin(q1) - y;
eq3 = @(q2, q3) 0.1392 - 0.05 + 0.135*cos(q2) + 0.147*cos(q2 + q3) - z;

% Initial guess for q2 and q3
initialGuess = [0, 0];

% Use fsolve to solve the system of equations

opts = optimoptions(@fsolve, 'Display', 'off', 'Algorithm', 'levenberg-marquardt');

solution = fsolve(@(x) [eq1(x(1), x(2)); eq2(x(1), x(2)); eq3(x(1), x(2))], initialGuess,opts);

q2 = solution(1);
q3 = solution(2);

q4 = pi/2 - q3 - q2;

q5 = 0; %Change later when needed

q = [q1,q2,q3,q4,q5];



