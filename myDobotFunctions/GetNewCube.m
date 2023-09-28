function [blockInformation,programStop] = GetNewCube(counter,programStop,blockInformation,redBlockPos,blueBlockPos,greenBlockPos)
%GetNewCube Generates a new cube based on user input and produces and stores relevant values

    %% Gets a user input to determine next block
        
    validInput = false; % Initialize a flag to indicate if the input is valid
    
    while validInput == false
        userInput = input(['Please enter either r, b, g or x for a red, blue,' ...
            ' green or random cube. Press e to exit the program.' ...
            ' Press return to confirm your selection: '], 's'); % 's' specifies string input
        
        % Check if the userInput is one of the valid choices
        if ismember(userInput, ['r', 'b', 'g', 'x', 'e'])
            validInput = true; % Set the flag to true to exit the loop
        else
            disp('Invalid input. Please enter either r, b, g, x or e.'); % Display an error message
        end
    end
    
    % Now, you can use the valid userInput
    disp(['You selected: ' userInput]);
    

    if userInput == 'e'
        
        programStop = true;

    else
        %% Block Number
    
        blockInformation(counter,1) = counter; %assigns current number to the first row of the array
        
        %% Random starting coordinate
        
        % Define the limits for x, y, and z
        x_min = 0.17;
        x_max = 0.3;
        
        y_min = -0.12;
        y_max = 0.12;
        
        z_min = 0;
        z_max = 0.1;
                                
        xyzPos = RandCoordinates([x_min,x_max,y_min,y_max,z_min,z_max]); %Custom function to get random coordinates within a limit
        
        blockInformation(counter,3:5) = xyzPos; %Columns 3 to 5 store blocks initial location
        
        %% Colour ID and target location
        %1 is red
        %2 is blue
        %3 is green
    
        randNumber = 0;
    
        blockHeight = 0.02;
        
        if userInput == 'x'
            randNumber = randsample(3,1); % Assigns random colour if needed
        end
        
        if userInput == 'r'|| randNumber == 1
        
            blockInformation(counter,6:8) = [redBlockPos(1,4),redBlockPos(2,4),...
                redBlockPos(3,4)+((sum(blockInformation(:, 2) == 1))*blockHeight)];
                %Stores target position in columns 6 to 8. A multiplier is
                %added to the z value to account for exisiting block
        
            % Calculate the rotation about the global z axis.
            blockInformation(counter,9) = atan2(redBlockPos(2,1), redBlockPos(1,1));
    
            blockInformation(counter,2) = 1; %Stores colour in 2nd column
            
        elseif userInput == 'b'|| randNumber == 2
        
            blockInformation(counter,6:8) = [blueBlockPos(1,4),blueBlockPos(2,4),...
                blueBlockPos(3,4)+((sum(blockInformation(:, 2) == 2))*blockHeight)];
                %Stores target position in columns 6 to 8. A multiplier is
                %added to the z value to account for exisiting blocks
    
            % Calculate the rotation about the global z axis.
            blockInformation(counter,9) = atan2(blueBlockPos(2,1), blueBlockPos(1,1));
    
            blockInformation(counter,2) = 2; %Stores colour in 2nd column
        
        elseif userInput == 'g'|| randNumber == 3
        
            blockInformation(counter,6:8) = [greenBlockPos(1,4),greenBlockPos(2,4),...
                greenBlockPos(3,4)+((sum(blockInformation(:, 2) == 3))*blockHeight)];
                %Stores target position in columns 6 to 8. A multiplier is
                %added to the z value to account for exisiting blocks
    
            % Calculate the rotation about the global z axis.
            blockInformation(counter,9) = atan2(greenBlockPos(2,1), greenBlockPos(1,1));
    
            blockInformation(counter,2) = 3; %Stores colour in 2nd column
    
        else
            disp("Warning, an error has occured when attempting to assign block data")
        
        end
    
    end

end