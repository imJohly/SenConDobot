function  MoveRealRobot(qValues)
%CONTROLGRIPPERREALROBOT Summary of this function goes here



jointTarget = qValues % Remember that the Dobot has 4 joints by default.

[targetJointTrajPub,targetJointTrajMsg] = rospublisher('/dobot_magician/target_joint_states');
trajectoryPoint = rosmessage("trajectory_msgs/JointTrajectoryPoint");
trajectoryPoint.Positions = jointTarget;
targetJointTrajMsg.Points = trajectoryPoint;

send(targetJointTrajPub,targetJointTrajMsg);

pause(3)

qnew = GetJointStatesRealRobot();

if ~(qValues == qnew)
    qValues
    qnew
    pause(2)
end

end
