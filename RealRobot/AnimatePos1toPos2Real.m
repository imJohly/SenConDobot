function [] = AnimatePos1toPos2Real(myRobot,blockObjects,counter,pos2,steps,blockCarry, gripper, zGripperOffset, vertices, arduinoPort, noEstop, status, simulationMode, loggerFile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if simulationMode.Sim == true

    q1 = myRobot.model.getpos();
    q2sim = DobotIkReal(myRobot,pos2);
    
    qMatrix = InterpolatedJointAngles(q1,q2sim,steps);
    % Variables for the Estop intergration to know when to display strings
    % so it doesnt write it every scan
    first = true;
    held = false;
    lightCurtainSafe = true;
    % Animates through the qMatrix:
    for trajStep = 1:steps

        % check if there is an estop connected to the system
        if ~noEstop
            ReadArduino(arduinoPort, status, loggerFile,first,held,lightCurtainSafe)
         end

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

    %real robot part
    if simulationMode.Real == true

        z_difference_sim_vs_real = -0.02;

        realpos2 = pos2;
        realpos2(3) = realpos2(3) + z_difference_sim_vs_real;

        q2RealSim = DobotIkReal(myRobot,realpos2);

        q2real = myRobot.ModelQToRealQ(q2RealSim);

        MoveRealRobot(q2real)

        if gripper == 1

            ControlGripperRealRobot(false)

        elseif gripper == 2

            ControlGripperRealRobot(true)

        end
    end

end