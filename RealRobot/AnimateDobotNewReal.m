function [] = AnimateDobotNewReal(myRobot, blockInformation, blockObjects, counter, stepsLong, stepsShort, offset, zGripperOffset, vertices)
%AnimateDobotNew

    %extract start position from Dobot
    startPos = transl(blockInformation(counter,3:5))*trotz(counter,6)*transl(0,0,zGripperOffset);
    
    %calculate offset position from start
    startPosOffset = startPos*transl(0,0,offset);
    
    %extract end position from Dobot
    targetPos = transl(blockInformation(counter,7:9))*trotz(counter,10)*transl(0,0,zGripperOffset);
    
    %calculate offset position from end
    targetPosOffset = targetPos*transl(0,0,offset);

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, startPosOffset,  stepsLong,  0, 0, zGripperOffset, vertices) %current position to block start offset

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, startPos,        stepsShort, 0, 1, zGripperOffset, vertices) %current position to block start             gripper close

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, startPosOffset,  stepsShort, 1, 0, zGripperOffset, vertices) %current position to block start offset      carry

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, targetPosOffset, stepsLong,  1, 0, zGripperOffset, vertices) %current position to block target offset     carry

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, targetPos,       stepsShort, 1, 2, zGripperOffset, vertices) %current position to block target,           carry, gripper open

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, targetPosOffset, stepsShort, 0, 0, zGripperOffset, vertices) %current position to block target offset




%1 animate function
% takes in required data from block information (start, and end values)