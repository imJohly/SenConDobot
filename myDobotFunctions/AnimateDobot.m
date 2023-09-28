function [] = AnimateDobot(baseTr, i, myRobot, vertices, block, steps, zGripperOffset, varargin)

%AnimateDobot Animates myRobot from the current position to the target position

    narginchk(7,13) %Checks for at least 3 inputs and at most 6 inputs

    %% Need to include
    
    %baseTr                 % position of base
    %i                      % to be used when in a for looop
    %vertices               % block object
    %block                  % which block is being moved
    %steps                  % number of steps in animation
    %zGripperOffset         % how far above block end effector stops to allow for gripper


    %% Varagin Inputs - Default values and assign value

    %Sets default values of optional inputs:

    target = 0;             % target location (used when block is being picked up)
    guess = 0;              % guess angles of q (used when block is being picked up)
    qAngles = 0;            % angles to deposit (used when block is being placed down)
    offset = 0;             % how far the robot rises from its current position (used after picking up/ placing down a block)
    blockCarry = 0;         % sets the can to be carried (0 - dont carry, 1 - carry block)
    gripperQuery = 0;       % sets the gripper to open or close (0 - do nothing, 1 - close gripper, 2 - open gripper)
    adjustment = eye(4);    % manual adjustment of gripper end position


    %Assigns optional inputs if provideded by the user:

    if numel(varargin) >= 1
        target = varargin{1};
    end

    if numel(varargin) >= 2
        guess = varargin{2};
    end

    if numel(varargin) >= 3
        qAngles = varargin{3};
    end

    if numel(varargin) >= 4
        offset = varargin{4};
    end

    if numel(varargin) >= 5
        blockCarry = varargin{5};
    end

    if numel(varargin) >= 6
        gripperQuery = varargin{6};
    end

    if numel(varargin) >= 7
        adjustment = varargin{7};
    end


    %% Main function code


    q1 = myRobot.model.getpos(); % Sets q1 as the current robot position


    % Set q2 to given angles, or use ikcon to guess angles based on a target position and a guess:

    if qAngles == 0

        Tnext = transl(target(i,1),target(i,2),target(i,3)+zGripperOffset+offset)*adjustment;
    
        q2 = myRobot.model.ikcon(Tnext, guess(i,:));

    else

        q2 = qAngles;

    end


    % Generates a trapezoidal velocity qMatrix based on q1 and q2

    qMatrix = InterpolatedJointAngles(q1,q2,steps);


    % Animates through the qMatrix:

    for trajStep = 1:steps

        % Moves the can if specified

        myRobot.model.animate(qMatrix(trajStep,:));

            %if block carry is set to 1, move the block as well
     
            if blockCarry == 1
                trNew = FkineTrDobot((qMatrix(trajStep,:)),baseTr);       
                trNew(3,4) = trNew(3,4)-zGripperOffset;
                trNew = trNew*troty(pi);
                
                transformedVertices = [vertices,ones(size(vertices,1),1)] * trNew';
                set(block(i),'Vertices',transformedVertices(:,1:3));
                 
            else
    
            end

        drawnow();
        
    end


    %Displays information about the position to the command window
    %Uses fkine of the target q2 values versus the actual q2 values

    targetLocation = myRobot.model.fkine(q2);
    targetLocation = targetLocation.T;
    disp(['Target location = ', num2str(targetLocation(1,4)),' ',num2str(targetLocation(2,4)),' ',num2str(targetLocation(3,4))])
    actualPos = myRobot.model.fkine(myRobot.model.getpos);
    actualPos = actualPos.T;
    disp(['Acutal location = ', num2str(actualPos(1,4)),' ',num2str(actualPos(2,4)),' ',num2str(actualPos(3,4))])
    

    %Can be used later to control the opening and closing of the gripper

    if gripperQuery == 1 %close

        %code to animate gripper closing

    elseif gripperQuery == 2 %open

        %code to animate gripper opening
               
    end
 
end