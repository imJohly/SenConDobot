function [] = EStopRealRobot()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
safetyStateMsg.Data = 3;
send(safetyStatePublisher,safetyStateMsg);
disp('Software Estop Sent To Robot')
pause(2)
end