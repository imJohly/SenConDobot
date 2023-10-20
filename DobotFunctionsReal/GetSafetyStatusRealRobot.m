function [currentSafetyStatus] = GetSafetyStatusRealRobot()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
safetyStatusSubscriber = rossubscriber('/dobot_magician/safety_status');
pause(2); %Allow some time for MATLAB to start the subscriber
currentSafetyStatus = safetyStatusSubscriber.LatestMessage.Data;
end