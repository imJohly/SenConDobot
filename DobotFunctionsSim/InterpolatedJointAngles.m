function [qMatrix] = InterpolatedJointAngles(q1,q2,steps, varargin)
%InterpolatedJointAngles Generates values between q1 and q2 using a Linear segment with parabolic blend
%Also allows 'waypoints' to create a customised path, allows for either 1, 2 or 3 waypoint inputs

    narginchk(3,6) %Checks for at least 3 inputs and at most 6 inputs

    %Sets default values of optional inputs
    qint1 = [];
    qint2 = [];
    qint3 = [];

    %Assigns optional inputs if provideded by the user

    if numel(varargin) >= 1
        qint1 = varargin{1};
    end

    if numel(varargin) >= 2
        qint2 = varargin{2};
    end
    
    if numel(varargin) >= 3
        qint3 = varargin{3};
    end


    qMatrix = nan(steps,numel(q1)); % Create memory allocation for variables

    s = lspb(0,1,steps); %Linear segment with parabolic blend


    if numel(varargin) == 0

        for stepNumber = 1:steps
            
            qMatrix(stepNumber,:) = (1-s(stepNumber))*q1 + s(stepNumber)*q2;          	% Generate interpolated joint angles

        end
        
    elseif numel(varargin) == 1

        halfway = floor(steps/2);

        for stepNumber = 1:steps

            if stepNumber <= halfway
                qMatrix(stepNumber,:) = (1-s(stepNumber))*q1 + s(stepNumber)*qint1;
            else
                qMatrix(stepNumber,:) = (1-s(stepNumber))*qint1 + s(stepNumber)*q2;
            end

        end

    elseif numel(varargin) == 2

        thirdway = floor(steps/3);

        for stepNumber = 1:steps

            if stepnumber <= thirdway
                qMatrix(stepNumber,:) = (1-s(stepNumber))*q1 + s(stepNumber)*qint1;
            elseif stepnumber <= 2*thirdway
                qMatrix(stepNumber,:) = (1-s(stepNumber))*qint1 + s(stepNumber)*qint2;
            else
                qMatrix(stepNumber,:) = (1-s(stepNumber))*qint2 + s(stepNumber)*q2;
            end

        end

    elseif numel(varargin) == 3

        quarterway = floor(steps/4);

        for stepNumber = 1:steps

            if stepnumber <= quarterway
                qMatrix(stepNumber,:) = (1-s(stepNumber))*q1 + s(stepNumber)*qint1;
            elseif stepnumber <= 2*quarterway
                qMatrix(stepNumber,:) = (1-s(stepNumber))*qint1 + s(stepNumber)*qint2;
            elseif stepnumber <= 3*quarterway
                qMatrix(stepNumber,:) = (1-s(stepNumber))*qint2 + s(stepNumber)*qint3;                
            else
                qMatrix(stepNumber,:) = (1-s(stepNumber))*qint3 + s(stepNumber)*q2;
            end

        end           
        
    end
      
end
