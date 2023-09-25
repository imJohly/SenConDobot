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
RepCubePos = transl(-0.05,-0.25,0);
BlueCubePos = transl(-0.05,0.25,0);
GreenCubePos = transl(0.25,0.1,0);

RedCube = PlaceObject('RedCube.ply');
vertices = get(RedCube,'Vertices');
transformedVertices = [vertices,ones(size(vertices,1),1)] * RepCubePos';
set(RedCube,'Vertices',transformedVertices(:,1:3));

BlueCube = PlaceObject('BlueCube.ply');
vertices = get(BlueCube,'Vertices');
transformedVertices = [vertices,ones(size(vertices,1),1)] * BlueCubePos';
set(BlueCube,'Vertices',transformedVertices(:,1:3));

GreenCube = PlaceObject('GreenCube.ply');
vertices = get(GreenCube,'Vertices');
transformedVertices = [vertices,ones(size(vertices,1),1)] * GreenCubePos';
set(GreenCube,'Vertices',transformedVertices(:,1:3));


floor = surf([-0.35,-0.35;0.45,0.45] ,[-0.45,0.45;-0.45,0.45] ,[0,0;0,0] ,'CData',imread('Floor.jpg') ,'FaceColor','texturemap');
rotate(floor,[0,0,1],180);

%% UTS Dobot
r = Dobot;
mdl_gripper


r.model.base = transl(0,0,0) * rpy2tr(0,0,0);
r.model.animate(realQ);

OPEN_GRIPPER_Q = [0 -1 0];
CLOSE_GRIPPER_Q = [0 -pi/7 pi/5];

% Set Gripper

         %Gripper1.plot3d(CLOSE_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','path','D:\OneDrive - UTS\University\Subjects\Year 3\Sem 2\41013 Industrial Robotics\Assignments\Matlab\Submission\Gripper' );
         %Gripper2.plot3d(CLOSE_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','path','D:\OneDrive - UTS\University\Subjects\Year 3\Sem 2\41013 Industrial Robotics\Assignments\Matlab\Submission\Gripper' );
          
         % plot vs plot3d
         
         Gripper1.plot(q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','nobase','noshadow');
         Gripper2.plot(q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','nobase','noshadow');


%Set Gripper on robot
        gripperLoc = r.model.fkineUTS(r.model.getpos);
        Gripper1.base = gripperLoc;
        Gripper2.base = gripperLoc;
        Gripper1.animate(Gripper1.getpos);
        Gripper2.animate(Gripper2.getpos);


Vol = AidanVolume(r.model,true)
lighting none;

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