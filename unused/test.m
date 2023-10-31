% clear
% rosshutdown
% rosinit
% 
% MoveRealRobot([-pi/4, 0.0, 0.0, 0]);
% 
% rosshutdown

[safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
safetyStateMsg.Data = 2;
send(safetyStatePublisher,safetyStateMsg);

% InitialiseRealRobot();
% EStopRealRobot();