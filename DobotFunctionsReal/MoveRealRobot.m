function  MoveRealRobot(qValues,noEstop,arduinoPort, status, loggerFile,first,held,lightCurtainSafe,simulationMode)
%CONTROLGRIPPERREALROBOT Summary of this function goes here



jointTarget = qValues; % Remember that the Dobot has 4 joints by default.

[targetJointTrajPub,targetJointTrajMsg] = rospublisher('/dobot_magician/target_joint_states');
trajectoryPoint = rosmessage("trajectory_msgs/JointTrajectoryPoint");
trajectoryPoint.Positions = jointTarget;
targetJointTrajMsg.Points = trajectoryPoint;

send(targetJointTrajPub,targetJointTrajMsg);



if ~noEstop
    ReadArduino(arduinoPort, status, loggerFile,first,held,lightCurtainSafe,simulationMode)
end

pause(1)

qnew = GetJointStatesRealRobot();

if ~(qValues == qnew)
    if ~noEstop
        ReadArduino(arduinoPort, status, loggerFile,first,held,lightCurtainSafe,simulationMode)
    end
    pause(2)
end
end


