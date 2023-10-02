function [] = AnimateDobotNew(myRobot, blockInformation, counter, stepsLong, stepsShort, offset, zGripperOffset)
%AnimateDobotNew

startPos = transl(blockInformation(counter,3:5))*trotz(counter,6);

startPosOffset = startPos*transl(0,0,offset)

targetPos = transl(blockInformation(counter,7:9))*trotz(counter,10);

targetPosOffset = targetPos*transl(0,0,offset)




%1 animate function
% takes in required data from block information (start, and end values)