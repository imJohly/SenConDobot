clc
clf
clear all
hold on

mdl_dobot
STEPS = 50;


q = zeros(1,5);

pickPosition = transl(0.1, -0.2 , 0.2)
offset = transl(0,0,0.05) * rpy2tr(0,0,pi/2);

plot3(pickPosition(1,4),pickPosition(2,4),pickPosition(3,4),'r.');

bluePlace = transl(-0.1,0.25,0);


floor = surf([-0.35,-0.35;0.45,0.45] ,[-0.45,0.45;-0.45,0.45] ,[0,0;0,0] ...
,'CData',imread('Floor.jpg') ,'FaceColor','texturemap');

rotate(floor,[0,0,1],180);

%% My Dobot
realQ = [0,pi/4,pi/4,0,0];
Dobot.base = transl(0,0,0) * rpy2tr(0,0,0);
Dobot.plot(q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','nobase','noshadow');
lighting none;
axis([-0.5,0.5,-0.5,0.5,-0.2,0.5])

q = Dobot.getpos;
q = Dobot.ikcon(pickPosition ,Dobot.getpos);
Qmatrix = jtraj(Dobot.getpos,q,STEPS);
for i = 1:STEPS

    Dobot.animate(Qmatrix(i,:));
    %pause(0.05)
end

AidanVolume(Dobot)
% q = Dobot.ikcon(bluePlace,Dobot.getpos);
% Qmatrix = jtraj(Dobot.getpos,q,STEPS);
% for i = 1:STEPS
% 
%     Dobot.animate(Qmatrix(i,:));
%     %pause(0.05)
% end

%% UTS Dobot
% r = DobotMagician();
% r.model.plot(realQ);
% r.model.base = transl(0,0,0);
% r.model.animate(q);
% 
% for i = 1:STEPS
% 
%     r.model.animate(Qmatrix(i,:));
%     pause(0.05)
% end




% Clears plot for somereason
%vol = VolumePC(r.model);


%% Functionsrobot


function [matrix] = GetIK(robot,position,STEPS,guess,testpoint)

    Q = robot.getpos();
    Q = robot.ikcon(position,guess);
    matrix = jtraj(robot.getpos,Q,STEPS);
if nargin > 4
      TestPoint(robot,position)

end
end