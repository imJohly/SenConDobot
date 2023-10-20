clear all;
clc;
clear arduinoPort;

% Create a serial port object for Arduino
arduinoPort = serialport('COM3', 9600,"Timeout",300); % Replace 'COMx' with your actual port

% Initialize the button state
heldState = false;
count = 0;

Running = '1';
Stopped = '0';
Held = '2';
dataLength = 2;
dataArray = [];
status = struct('Running', '1', 'Stopped', '0', 'Held', '2');
    first = true;
    held = false;
    lightCurtainSafe = true;

while true
    % Read data from the Arduino
    %data = read(arduinoPort, dataLength, "char")
    %dataArray(end + 1) = data;
    
    sysStatus = read(arduinoPort, dataLength, "char"); %read the estop data
    eStopStatus = sysStatus(1);
    lightCurtainStatus = sysStatus(2);
    lightCurtainSafe = true;
            % if estop is pushed wait
            while ~strcmp(eStopStatus,status.Running)   %if the estop data is the stopped state wait for the estop 
                sysStatus = read(arduinoPort, dataLength, "char");
                eStopStatus = sysStatus(1);
                lightCurtainStatus = sysStatus(2);

                if first & strcmp(eStopStatus,status.Stopped)
                     %loggerFile.mlog = {loggerFile.ERROR,'Assignment2',['E Stop Pressed']};
                     disp('Emergency Stop Pressed')
                     first = false;
                     held = false;
                end
                if ~held & strcmp(eStopStatus,status.Held)
                     %loggerFile.mlog = {loggerFile.WARN,'Assignment2',['Program Held: Press Start To Resume']};
                     disp('Program Held: Press Start To Resume')
                     held = true;
                     first = true;
                end

                if strcmp(eStopStatus,status.Running)
                     %loggerFile.mlog = {loggerFile.WARN,'Assignment2',['Returned To Running']};
                     disp('Returned To Running')
                end


            end
            while strcmp(lightCurtainStatus,'0')
                sysStatus = read(arduinoPort, dataLength, "char");
                eStopStatus = sysStatus(1);
                lightCurtainStatus = sysStatus(2);

                if lightCurtainSafe
                    disp('Light Curtain Broken: Clear LC and press resume')  
                    lightCurtainSafe = false;
                end


            end

    %% This code writes data to the arduino. if stopped send stopped again to go into held
    % pause(3)
    % if strcmp(data,Running)
    %     write(arduinoPort, Stopped, "char");
    % elseif strcmp(data,Held)
    %     write(arduinoPort, Running, "char");
    % elseif strcmp(data,Stopped)
    %     write(arduinoPort, Stopped, "char");
    % end
    %%

    % if strcmp(data,Running)
    %     count = count + 1
    % elseif strcmp(data,Stopped)
    %     pause(1);
    %     break
    % else % would be held state
    %     heldState = true;
    % end

  
    
    % Add a delay to control the data read rate
    pause(0.1);
end


% Clean up when done
clear arduinoPort;
