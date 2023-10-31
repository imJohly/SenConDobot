function  MoveRealRobot(qValues,noEstop,arduinoPort, status, loggerFile,first,held,lightCurtainSafe,simulationMode)
%CONTROLGRIPPERREALROBOT Summary of this function goes here



jointTarget = qValues; % Remember that the Dobot has 4 joints by default.

[targetJointTrajPub,targetJointTrajMsg] = rospublisher('/dobot_magician/target_joint_states');
trajectoryPoint = rosmessage("trajectory_msgs/JointTrajectoryPoint");
trajectoryPoint.Positions = jointTarget;
targetJointTrajMsg.Points = trajectoryPoint;

% Send joint message
send(targetJointTrajPub,targetJointTrajMsg);


%% What i think it should be
%check e stop status.
if ~noEstop
    ReadArduino(arduinoPort, status, loggerFile,first,held,lightCurtainSafe,simulationMode)
end

qnew = GetJointStatesRealRobot();
%if the goal q's do not equal current position then you are not at the goal
% check to see the estop status
while ~(qValues == qnew)
    if ~noEstop
        ReadArduino(arduinoPort, status, loggerFile,first,held,lightCurtainSafe,simulationMode)
    end
    qnew = GetJointStatesRealRobot();
end
 


end


