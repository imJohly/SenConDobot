function [] = InitialiseRealRobot()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
safetyStateMsg.Data = 2;
send(safetyStatePublisher,safetyStateMsg);

disp('it did');
end