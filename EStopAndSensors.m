function [noEstop, status, arduinoPort ] = EStopAndSensors(desiredPort,L)
%EStopAndSensors: Contains E-stop and sensor codem returns if there is an
%E-stop and also the status of the E-stop.

clear arduinoPort;

eStopDesiredPort = desiredPort;
ports = serialportlist;
noEstop = false;
% Create a serial port object for Arduino
% Check if Estop is connected.
arduinoPort = false;
if any(strcmp(ports, eStopDesiredPort))
    arduinoPort = serialport(eStopDesiredPort, 9600,"Timeout",300); 
    L.mlog = {L.DEBUG,'Assignment2',['E Stop Is Connected']};
    disp('Emergency Stop is connected.');
else
    L.mlog = {L.ERROR,'Assignment2',['E Stop Not Connected']};
    disp('Emergency Stop is not connected.');
    noEstop = true;
end

% Estop Status variables
Running = '1';
Stopped = '0';
Held = '2';
status = struct('Running', '1', 'Stopped', '0', 'Held', '2');
dataLength = 2;

% Read data from the Arduino
%sysStatus = read(arduinoPort, 2, "char");

end