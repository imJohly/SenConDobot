function [] = ReadArduino(arduinoPort, status, loggerFile,first,held,lightCurtainSafe,simulationMode)

sysStatus = read(arduinoPort, 2, "char"); %read the estop data
eStopStatus = sysStatus(1);
lightCurtainStatus = sysStatus(2);
lightCurtainSafe = true; %set the lightcurtian varaible back to safe
% if estop is pushed wait
while ~strcmp(eStopStatus,status.Running)   %if the estop data is the stopped state wait for the estop
    sysStatus = read(arduinoPort, 2, "char");
    eStopStatus = sysStatus(1);

    if first & strcmp(eStopStatus,status.Stopped)
        loggerFile.mlog = {loggerFile.ERROR,'Assignment2',['E Stop Pressed']};
        disp('Emergency Stop Pressed')
        first = false;
        held = false;
        if simulationMode.Real
            EStopRealRobot();
        end
    end
    if ~held & strcmp(eStopStatus,status.Held)
        loggerFile.mlog = {loggerFile.WARN,'Assignment2',['Program Held: Press Start To Resume']};
        disp('Program Held: Press Start To Resume')
        held = true;
        first = true;
    end

    if strcmp(eStopStatus,status.Running)
        loggerFile.mlog = {loggerFile.WARN,'Assignment2',['Returned To Running']};
        disp('Returned To Running')

        
    end


end
% Check for lightcurtain safety
while strcmp(lightCurtainStatus,'0')
    sysStatus = read(arduinoPort, 2, "char");
    lightCurtainStatus = sysStatus(2);

    if lightCurtainSafe
        loggerFile.mlog = {loggerFile.ERROR,'Assignment2',['Light Curtain Broken']};
        disp('Light Curtain Broken: Clear LC and press resume')
        lightCurtainSafe = false;
        if simulationMode.Real
            EStopRealRobot();
        end
    end

end





end


