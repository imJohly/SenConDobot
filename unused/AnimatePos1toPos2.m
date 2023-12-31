function [] = AnimatePos1toPos2(myRobot,blockObjects,counter,pos2,steps,blockCarry, gripper, zGripperOffset, vertices)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    q1 = myRobot.model.getpos();
    q2 = DobotIk(myRobot,pos2);
    
    qMatrix = InterpolatedJointAngles(q1,q2,steps);
    
    % Animates through the qMatrix:
    for trajStep = 1:steps
     
        myRobot.model.animate(qMatrix(trajStep,:));

            %if block carry is set to 1, move the block as well    
            if blockCarry == 1
                trNew = FkineTrDobot(qMatrix(trajStep,:));       
                trNew(3,4) = trNew(3,4)-zGripperOffset;

                MoveObject(blockObjects(counter),trNew,vertices)
                 
            else
    
            end

        drawnow();
        
    end


end