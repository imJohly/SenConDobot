% clear
% 
% r = Dobot;
% 
% tgt = [0 0 0 0; 0 0 0 0; 0 0 0 0; 0 0 0 0];
% qnew = DobotIk(r, tgt);
% 
% ControlGripperRealRobot(true);
% 
% MoveRealRobot(qnew(1:4));

% q = [0 0 0 0];
% MoveRealRobot(q);
% 
% ControlGripperRealRobot(true);
% 
% q = [0 pi/4 pi/4 0];
% MoveRealRobot(q);
% 
% ControlGripperRealRobot(false);
% 
% q = [-pi/2 0 0 0];
% MoveRealRobot(q);
% 
% q = [-pi/2 pi/4 pi/4 0];
% MoveRealRobot(q);
% 
% ControlGripperRealRobot(true);
% 
% q = [pi/2 0 0 0];
% MoveRealRobot(q);
% 
% q = [pi/2 pi/4 pi/4 0];
% MoveRealRobot(q);

q = [0 deg2rad(45) deg2rad(45) 0];
MoveRealRobot(q);