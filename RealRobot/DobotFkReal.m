function [EndEffectorPos] = DobotFkReal(myRobot,q)
%DobotFkReal Better Dobot Fkine calculaotr
%   Detailed explanation goes here

    q1 = q(1);
    q2 = q(2);
    q3 = q(3);
    % q4 = q(4);
    q5 = q(5)+q(1);

    % Get link values from Dobot
    link1d = myRobot.model.links(1).d;
    link2a = myRobot.model.links(2).a;
    link3a = myRobot.model.links(3).a;
    link4a = myRobot.model.links(4).a;
    link5d = myRobot.model.links(5).d;
    
    % Equations for q2 and q3
    x = (link2a * sin(q2) + link3a * sin(q2 + q3) + link4a) * cos(q1);
    y = (link2a * sin(q2) + link3a * sin(q2 + q3) + link4a) * sin(q1);
    z = link1d + link5d + link2a * cos(q2) + link3a *cos(q2 + q3);
    r = q5;

    EndEffectorPos = transl(x,y,z)*trotz(r);

end