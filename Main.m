%% Run this section to delete objects
                
try 
    DeleteObjects(RedCube,BlueCube,GreenCube,floor);
                % ^ Input all objects to delete here
catch
    disp("No objects to delete")
end
              
%%
clc
clf
clear all
hold on


STEPS = 50;


q = zeros(1,5);
realQ = [0,pi/4,pi/4,0,0];

pickPosition = transl(0.25,0.1,0);

offset = transl(0,0,0.05) * rpy2tr(0,0,pi/2);

plot3(pickPosition(1,4),pickPosition(2,4),pickPosition(3,4),'r.');

%% Set Up Objects

%Placing in objects
RedCube = PlaceObject('RedCube.ply');
BlueCube = PlaceObject('BlueCube.ply');
GreenCube = PlaceObject('GreenCube.ply');

%Target position of cubes
RedCubePos = transl(-0.05,-0.25,0);
BlueCubePos = transl(-0.05,0.25,0);
GreenCubePos = transl(0.25,0.1,0);

%Function to Move the cubes
MoveObject(RedCube, RedCubePos)
MoveObject(BlueCube, BlueCubePos)
MoveObject(GreenCube, GreenCubePos)

%Placing in the floor
floor = surf([-0.6,-0.6;0.5,0.5] ,[-0.6,0.6;-0.6,0.6] ,[0,0;0,0]...
,'CData',imread('Floor.jpg') ,'FaceColor','texturemap');
rotate(floor,[0,0,1],180);

%% UTS Dobot
r = Dobot;
% mdl_gripper
% 
% 
% r.model.base = transl(0,0,0) * rpy2tr(0,0,0);
%  r.model.animate(realQ);
% 
% OPEN_GRIPPER_Q = [0 -1 0];
% CLOSE_GRIPPER_Q = [0,0.5,0];
% 
% % Set Gripper
% 
%         Gripper1.plot3d(CLOSE_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','path','D:\OneDrive - UTS\University\Subjects\Year 3\Sem 2\41014 Sensors and Control\Git\SenConDobot\Gripper\Gripper1' );
% 
%         Gripper2.plot3d(CLOSE_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','path','D:\OneDrive - UTS\University\Subjects\Year 3\Sem 2\41014 Sensors and Control\Git\SenConDobot\Gripper\Gripper2' );
% 
%          % plot vs plot3d
% 
%          %Gripper1.plot(q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','nobase','noshadow');
%          %Gripper2.plot(q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','nobase','noshadow');
% 
% 
% %Set Gripper on robot
%         gripperLoc = r.model.fkineUTS(r.model.getpos);
%         Gripper1.base = gripperLoc;
%         Gripper2.base = gripperLoc;
%         Gripper1.animate(Gripper1.getpos);
%         Gripper2.animate(Gripper2.getpos);
% 
% 
%% Point Cloud and test point
pointCloud = AidanVolume(r.model,false,false);

testPoint = transl(0.3, 0, 0.1);
plot3(testPoint(1,4),testPoint(2,4),testPoint(3,4),'-O');
TestPoint(pointCloud,testPoint)

%%
%r.model.teach(realQ);
redGuess = [0.3142    1.2435    0.9111    0.9425         0]

q = r.model.getpos;
q = r.model.ikcon(pickPosition ,redGuess)
r.model.fkine(q)
Qmatrix = jtraj(r.model.getpos,q,STEPS);

axis([-0.5,0.5,-0.5,0.5,-0.2,0.5])

for i = 1:STEPS

    r.model.animate(Qmatrix(i,:));
    gripperLoc = r.model.fkineUTS(r.model.getpos);
    Gripper1.base = gripperLoc;
    Gripper2.base = gripperLoc;
    Gripper1.animate(Gripper1.getpos);
    Gripper2.animate(Gripper2.getpos);

    %pause(0.05)
end




%% AnimateDobot

block = 1; %array of block objects
vertices = 1; %array of block vertices
steps = 50;
zGripperOffset = 0.03;

% need a block array that updates - ID of the block objects
% need a vertices array that updates - Poistion of the block

blockInformation = zeros(1000,8);
programStop = false;
counter = 1;

while programStop == false    

    blockInformation = GetNewCube(counter,blockInformation,)

    q = DobotIk(x,y,z);




    counter = counter+1;

end


for i = 1:1

%(baseTr, i, myRobot, vertices, block, steps, zGripperOffset, target, guess, qAngles, offset, blockCarry, gripperQuery, adjustment)

% Move to above block start
AnimateDobot(baseTr,i,r,vertices,block,steps,zGripperOffset, target, guess, 0,       offset, 0,         0) 

% Move to block start, close gripper
AnimateDobot(baseTr,i,r,vertices,block,steps,zGripperOffset, target, guess, 0,       0,      0,         1) 

% Move to can above block start, move blok
AnimateDobot(baseTr,i,r,vertices,block,steps,zGripperOffset, target, guess, 0,       offset, 1,         0)

% Move to above block deposit, move block
AnimateDobot(baseTr,i,r,vertices,block,steps,zGripperOffset, 0,      0,     qAngles, offset, 1,         0) 

% Move to block deposit, move block, open gripper
AnimateDobot(baseTr,i,r,vertices,block,steps,zGripperOffset, 0,      0,     qAngles, 0,      1,         2) 

% Move to above block deposit
AnimateDobot(baseTr,i,r,vertices,block,steps,zGripperOffset, 0,      0,     qAngles, offset, 0,         0) 


end
%% Functionsrobot


function [matrix] = GetIK(robot,position,STEPS,guess,testpoint)

    Q = robot.getpos();
    Q = robot.ikcon(position,guess);
    matrix = jtraj(robot.getpos,Q,STEPS);
if nargin > 4
      TestPoint(robot,position)

end
end