function [JointStates] = GetJointStatesRealRobot()
%GetJoinStatesRealRobot Summary of this function goes here
%   Detailed explanation goes here


jointStateSubscriber = rossubscriber('/dobot_magician/joint_states'); % Create a ROS Subscriber to the topic joint_states
pause(2); % Allow some time for a message to appear
currentJointState = jointStateSubscriber.LatestMessage.Position; % Get the latest message
JointStates = currentJointState';
end

