clf
clear global
clc
%% Simulation Robot
r = Dobot;

%% Set Up Logging
L = log4matlab('Assignment2.log');
 

%% Set up Estop and sensors
clear arduinoPort;

desiredPort = 'COM3';
ports = serialportlist;
noEstop = false;
% Create a serial port object for Arduino
% Check if Estop is connected.
if any(strcmp(ports, desiredPort))
    arduinoPort = serialport(desiredPort, 9600,"Timeout",300); 
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
dataLength = 1;

% Read data from the Arduino
sysStatus = read(arduinoPort, dataLength, "char");
%% Set mode: Simulation, Real, Both
simulationMode = struct('Sim', false, 'Real', false, '');

%%

hold on;

%Adjust steps to fine tune robot motion
stepsLong = 50;
stepsShort = 20;

%Fine tune offset of robot above block and distance to gripper
offset = 0.05;
zGripperOffset = 0.05;

%Place location of the blocks
redBlockPos = transl(0,-0.2,0)*trotz(0);
blueBlockPos = transl(0,0.2,0)*trotz(0);
greenBlockPos = transl(-0.15,-0.2,0)*trotz(0);

blockInformation = zeros(100,9); %Can store up to 100 unique blocks at once, increase this number if needed
%blockInformation = [block_no.,block_colour, x_start, y_start, z_start, z_rot_start, x_end, y_end, z_end, z_rot_end]
%^ Shows what values are stored in each row from 1 to 9.
blockObjects = zeros(100,1);

programStop = false;
counter = 1;

while programStop == false    

    [blockInformation,blockObjects,programStop,vertices] = GetNewCubeReal(counter,programStop,blockInformation,blockObjects,redBlockPos,blueBlockPos,greenBlockPos);
    
    if blockInformation(counter,2) ~= 0

        AnimateDobotNewReal(r,blockInformation,blockObjects,counter,stepsLong,stepsShort,offset,zGripperOffset,vertices, arduinoPort, noEstop, status)

        counter = counter+1;

    end

end
%% edit logging file
edit('Assignment2.log');