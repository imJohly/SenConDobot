function [] = AnimateDobotNewReal(myRobot, blockInformation, blockObjects, counter, stepsLong, stepsShort, offsetAfterPick, zGripperOffset, vertices, arduinoPort, noEstop,status,simulationMode, loggerFile)
%AnimateDobotNew

    %extract start position from Dobot
    startPos = blockInformation(counter,3:6);
    startPos(3) = startPos(3) + zGripperOffset;
    
    %calculate offset position from start
    startPosOffset = startPos;
    startPosOffset(3) = startPosOffset(3) + offsetAfterPick;
    
    %extract end position from Dobot
    targetPos = blockInformation(counter,7:10);
    targetPos(3) = targetPos(3) + zGripperOffset;
    
    %calculate offset position from end
    targetPosOffset = targetPos;
    targetPosOffset(3) = targetPosOffset(3) + offsetAfterPick;

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, startPosOffset,  stepsLong,  0, 0, zGripperOffset, vertices, arduinoPort, noEstop, status, simulationMode,loggerFile) %current position to block start offset

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, startPos,        stepsShort, 0, 1, zGripperOffset, vertices, arduinoPort, noEstop, status, simulationMode,loggerFile) %current position to block start             gripper close

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, startPosOffset,  stepsShort, 1, 0, zGripperOffset, vertices, arduinoPort, noEstop, status, simulationMode,loggerFile) %current position to block start offset      carry

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, targetPosOffset, stepsLong,  1, 0, zGripperOffset, vertices, arduinoPort, noEstop, status, simulationMode,loggerFile) %current position to block target offset     carry

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, targetPos,       stepsShort, 1, 2, zGripperOffset, vertices, arduinoPort, noEstop, status, simulationMode,loggerFile) %current position to block target,           carry, gripper open

    AnimatePos1toPos2Real(myRobot, blockObjects, counter, targetPosOffset, stepsShort, 0, 0, zGripperOffset, vertices, arduinoPort, noEstop, status, simulationMode,loggerFile) %current position to block target offset
