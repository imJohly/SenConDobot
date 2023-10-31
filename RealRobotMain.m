classdef RealRobotMain < handle    
%#ok<*NASGU>
%#ok<*NOPRT>
%#ok<*TRYNC>

    properties (Constant)
    end

    methods
        function self = RealRobotMain()

            self.ClearPreviousData();
            self.Main();
              
        end
    end
     
    methods(Static)
    
        function ClearPreviousData()   
            %% Clear Previos Data
            clf;
            clear all;
            clc;
        
        end
    
    
        function Main()
        
            %% Set Up Logging
            L = log4matlab('DoBotProjectLog.log');
            
            %% Set mode: Simulation, Real, Both
            simulationMode = struct('Sim', false, 'Real', false);
            
            simulationMode.Sim = true;
            simulationMode.Real = false;
            
            gripperMode = struct('DH', false, 'Model', false);
            
            gripperMode.DH = false;
            gripperMode.Model = true;
            
            
            if simulationMode.Real == true
                rosshutdown
                pause(2)
                rosinit
            end
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
            
            %Final place location of the blocks
            redBlockPos = transl(0,-0.25,0)*trotz(0);
            blueBlockPos = transl(0,0.25,0)*trotz(0);
            greenBlockPos = transl(-0.15,-0.2,0)*trotz(0);
            
            
            %% Set up Estop and sensors
            [noEstop, status, arduinoPort] = EStopAndSensors('COM3',L);
            
            
            %% Simulation objects
            
            r = Dobot(baseTr);
            GripperOpenMatrix = PlotGripper(r,gripperMode,gripperSteps);
            
            %% Create point cloud for test point function
            [pointCloud,shp] = DoBotVolume(r,false,false,false);
            
            %%
            
            blockInformation = zeros(100,9); %Can store up to 100 unique blocks at once, increase this number if needed
            %blockInformation = [block_no.,block_colour, x_start, y_start, z_start, z_rot_start, x_end, y_end, z_end, z_rot_end]
            %^ Shows what values are stored in each row from 1 to 9.
            blockObjects = zeros(100,1);
            
            programStop = false;
            counter = 1;
            
            %Gets psotion of all cubes within camera frame
            
            robot_translation = [0, 0.28, -0.28];
            rot = rpy2tr(pi, 0, 0);
            robot_rotation = rot(1:3, 1:3);
            
            if simulationMode.Real
                objects = CameraGetCubes(robot_translation, robot_rotation);  
                ControlGripperRealRobot(true); % so it doesnt write it every scan
                first = true;
                held = false;
                lightCurtainSafe = true;
                MoveRealRobot([-pi/4,pi/4,0,0],noEstop,arduinoPort, status, L,first,held,lightCurtainSafe,simulationMode);
            else
                objects = 0;
            end
            
            while programStop == false    
            
                [blockInformation,blockObjects,programStop] = GetNewCubeReal(simulationMode, objects,...
                    counter,programStop,blockInformation,blockObjects,redBlockPos,blueBlockPos,greenBlockPos);
                
                if blockInformation(counter,2) ~= 0
            
                    AnimateDobotNewReal(r,blockInformation,blockObjects,counter,stepsLong,stepsShort,...
                        offsetAfterPick,zGripperOffset,GripperOpenMatrix, arduinoPort, noEstop, status, simulationMode, L)
            
                    counter = counter+1;
            
                end
            
            end
            %% edit logging file
            edit('DoBotProjectLog.log');

        end
    
    end

end
