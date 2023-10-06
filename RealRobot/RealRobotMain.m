clf
clear global
clc
%%
r = Dobot;

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

    [blockInformation,blockObjects,programStop,vertices] = GetNewCube(counter,programStop,blockInformation,blockObjects,redBlockPos,blueBlockPos,greenBlockPos);
    
    if blockInformation(counter,2) ~= 0

        AnimateDobotNew(r,blockInformation,blockObjects,counter,stepsLong,stepsShort,offset,zGripperOffset,vertices)

        counter = counter+1;

    end

end