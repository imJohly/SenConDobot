function [qSim, qReal] = DobotIkReal(myRobot,target)
%DobotIk Custom Inverse Kinematics for the Dobot

    x = target(1,4);
    y = target(2,4);
    z = target(3,4);
    
    % Calculate the rotation about the global z axis.
    rotation_global_z = pi/6;
  
    % Solve for q1
    q1 = atan2(y, x);
    
    % Get link values from Dobot
    link1d = myRobot.model.links(1).d;
    link2a = myRobot.model.links(2).a;
    link3a = myRobot.model.links(3).a;
    link4a = myRobot.model.links(4).a;
    link5d = myRobot.model.links(5).d;
    
    % Equations for q2 and q3
    eq1 = @(q2, q3) (link2a * sin(q2) + link3a * sin(q2-(pi/2)+q3) + link4a) * cos(q1) - x;
    eq2 = @(q2, q3) (link2a * sin(q2) + link3a * sin(q2-(pi/2)+q3) + link4a) * sin(q1) - y;
    eq3 = @(q2, q3) link1d + link5d + link2a * cos(q2) + link3a *cos(q2-pi/2+q3) - z;

    % Initial guess for q2 and q3
    initialGuess = [0, 0];
    
    % Use fsolve to solve the system of equations
    
    opts = optimoptions(@fsolve, 'Display', 'off', 'Algorithm', 'levenberg-marquardt');
    
    solution = fsolve(@(x) [eq1(x(1), x(2)); eq2(x(1), x(2)); eq3(x(1), x(2))], initialGuess,opts);
    
    q2 = solution(1);
    q3 = solution(2); 

    q3sim = q3 + pi;
 
    q3real = -q2 -q3sim;

    q4 = pi/2 - q3sim - q2;
    
    q5 = rotation_global_z;
    
    qSim = [q1,q2,q3sim,q4,q5];

    qReal = [q1,q2,q3real,q5];

end