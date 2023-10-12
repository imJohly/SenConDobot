function [] = AnimatePos1toPos2Real(myRobot,blockObjects,counter,pos2,steps,blockCarry, gripper, zGripperOffset, vertices)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    q1 = myRobot.model.getpos();
    q2sim = myRobot.model.ikcon(pos2,q1);
    
    qMatrix = InterpolatedJointAngles(q1,q2sim,steps);
    
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

    %real robot part
    z_difference_sim_vs_real = 0.04;
    realpos2 = pos2;
    realpos2(3,4) = realpos2(3,4)-z_difference_sim_vs_real;


    q2realsim = myRobot.model.ikcon(realpos2,GetJointStatesRealRobot());
    q2real = ModelQToRealQ(q2realsim);

    MoveRealRobot(q2real)

    if gripper == 1

       ControlGripperRealRobot(false)

    elseif gripper == 2

       ControlGripperRealRobot(true)

    end


end