clf
clear all
clc

%% Set Up Logging
L = log4matlab('Assignment2.log');

%% Global variables

%Base of the robot (x,y,z),(roll,pitch,yaw)
baseTr = transl(0,0,0) * rpy2tr(0,0,0);

%Adjust steps to fine tune robot motion
stepsLong = 50;
stepsShort = 20;
gripperSteps = 20;

%Fine tune offset of robot above block and distance to gripper
offsetAfterPick = 0.05; % How far the robot travels upwards after pickng up / putting down the block
zGripperOffset = 0.06; % How far the block is from the end effector

%Place location of the blocks
redBlockPos = transl(0,-0.25,0)*trotz(0);
blueBlockPos = transl(0,0.25,0)*trotz(0);
greenBlockPos = transl(-0.15,-0.2,0)*trotz(0);


%% Set up Estop and sensors
[noEstop, status, arduinoPort] = EStopAndSensors('COM3',L);

%% Set mode: Simulation, Real, Both
simulationMode = struct('Sim', false, 'Real', false);
simulationMode.Sim = true;
simulationMode.Real = false;

gripperMode = struct('DH', false, 'Model', false);
gripperMode.DH = false;
gripperMode.Model = true;

%% Simulation objects

if simulationMode.Real == true

    r = Dobot(baseTr);
    clf;

end

if simulationMode.Sim == true
 
[r,GripperOpenMatrix] = PlotRobotAndGripper(baseTr,gripperMode,gripperSteps);

end

%%

blockInformation = zeros(100,9); %Can store up to 100 unique blocks at once, increase this number if needed
%blockInformation = [block_no.,block_colour, x_start, y_start, z_start, z_rot_start, x_end, y_end, z_end, z_rot_end]
%^ Shows what values are stored in each row from 1 to 9.
blockObjects = zeros(100,1);

programStop = false;
counter = 1;

while programStop == false    

    [blockInformation,blockObjects,programStop,vertices] = GetNewCubeReal(counter,programStop,blockInformation,blockObjects,redBlockPos,blueBlockPos,greenBlockPos);
    
    if blockInformation(counter,2) ~= 0

        AnimateDobotNewReal(r,blockInformation,blockObjects,counter,stepsLong,stepsShort,offsetAfterPick,zGripperOffset,GripperOpenMatrix,vertices, arduinoPort, noEstop, status, simulationMode, L)

        counter = counter+1;

    end

end
%% edit logging file
edit('Assignment2.log');