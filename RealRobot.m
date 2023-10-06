ControlGripperRealRobot(false);

JointQ = [0 0 0 0];
MoveRealRobot(JointQ);

JointQ = [pi/2 0.2 0.2 -pi/2];
MoveRealRobot(JointQ);

ControlGripperRealRobot(true);

JointQ = [pi/2 0 0 -pi/2];
MoveRealRobot(JointQ);

JointQ = [0 0 0 0];
MoveRealRobot(JointQ);

% JointQ = [-pi/2 0 0 0];
% MoveRealRobot(JointQ);
% 
% JointQ = [pi/2 0 0 0];
% MoveRealRobot(JointQ);