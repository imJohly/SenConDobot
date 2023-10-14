function [] = AnimatePos1toPos2Real(myRobot,blockObjects,counter,pos2,steps,blockCarry, gripper, zGripperOffset, vertices, arduinoPort, noEstop, status)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    q1 = myRobot.model.getpos();
    q2sim = myRobot.model.ikcon(pos2,q1);
    
    qMatrix = InterpolatedJointAngles(q1,q2sim,steps);
    % Variables for the Estop intergration to know when to display strings
    % so it doesnt write it every scan
    first = true;
    held = false;
    % Animates through the qMatrix:
    for trajStep = 1:steps

        % check if there is an estop connected to the system
        if ~noEstop
            sysStatus = read(arduinoPort, 1, "char"); %read the estop data
            % if estop is pushed wait
            while ~strcmp(sysStatus,status.Running)   %if the estop data is the stopped state wait for the estop 
                sysStatus = read(arduinoPort, 1, "char");
                if first & strcmp(sysStatus,status.Stopped)
                     L.mlog = {L.ERROR,'Assignment2',['E Stop Pressed']};
                     disp('Emergency Stop Pressed')
                     first = false;
                end
                if ~held & strcmp(sysStatus,status.Held)
                     L.mlog = {L.WARN,'Assignment2',['Program Held: Press Start To Resume']};
                     disp('Program Held: Press Start To Resume')
                     held = false;
                end

                pause(1);
            end
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

    %real robot part
    z_difference_sim_vs_real = -0.02;
    realpos2 = pos2;
    realpos2(3,4) = realpos2(3,4)-z_difference_sim_vs_real;

    currentQReal = GetJointStatesRealRobot();
    currentQSim = myRobot.RealQToModelQ(currentQReal);


    q2realsim = myRobot.model.ikcon(realpos2,currentQSim);
    q2real = myRobot.ModelQToRealQ(q2realsim);

    MoveRealRobot(q2real)

    if gripper == 1

       ControlGripperRealRobot(false)

    elseif gripper == 2

       ControlGripperRealRobot(true)

    end


end