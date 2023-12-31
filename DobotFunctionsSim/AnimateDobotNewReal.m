function [] = AnimateDobotNewReal(myRobot, blockInformation, blockObjects, counter, stepsLong, stepsShort, offsetAfterPick, zGripperOffset, GripperOpenMatrix, arduinoPort, noEstop,status,simulationMode, loggerFile)
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

    if simulationMode.Sim == true
        %moves cube to start position
        vertices = get(blockObjects(counter),'Vertices');
        blockStart = transl(blockInformation(counter,3:5))*trotz(blockInformation(counter,6));
        MoveObject(blockObjects(counter), blockStart, vertices)
    end

    if simulationMode.Real == true
        vertices = 0;
       
    end

    blockCarry = [0,0,1,1,1,0];
    gripper = [0,1,0,0,2,0];
    pos2 = [startPosOffset,startPos,startPosOffset,targetPosOffset,targetPos,targetPosOffset];
    steps = [stepsLong, stepsShort, stepsShort, stepsLong, stepsShort, stepsShort];

    for i = 1:size(blockCarry,2)

        AnimatePos1toPos2Real(myRobot, i, blockObjects, counter, pos2, steps, ...
            blockCarry, gripper, GripperOpenMatrix, zGripperOffset, vertices, ...
            arduinoPort, noEstop, status, simulationMode,loggerFile)
    end

end
    