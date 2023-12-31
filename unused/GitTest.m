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


floor = surf([-0.5,-0.5;0.5,0.5] ,[-0.5,0.5;-0.5,0.5] ,[0,0;0,0] ...
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

VolumePC(Dobot)
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

function [volume] = VolumePC(robot)
    %profile clear;
    %profile on;
    
    stepDeg = 10;
    stepRads = deg2rad(stepDeg);
    qlim = robot.qlim;
    % Precalculate Point Cloud Size
    pointCloudeSize = prod(floor((qlim(1:4,2)-qlim(1:4,1))/stepRads + 1));
    pointCloud = zeros(pointCloudeSize,3);
    counter = 1;
    
    for q1 = qlim(1,1):stepRads:qlim(1,2)
        for q2 = qlim(2,1):stepRads:qlim(2,2)
            for q3 = qlim(3,1):stepRads:qlim(3,2)
                for q4 = qlim(4,1):stepRads:qlim(4,2)
                    %for q5 = qlim(5,1):stepRads:qlim(5,2)

                        %q2=0;
                        %q3 = 0;
                        %q4 = 0;
                        q5 = 0;
                        %q6 = 0;
                        q = [q1,q2,q3,q4,q5];

                        tr = robot.fkineUTS(q);

                        pointCloud(counter,:) = tr(1:3,4)';

                        counter = counter + 1 ;

                    %end
                end
            end
        end
    end
    
    plot3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'r.');
    
    %k = boundary(pointCloud);
    %trisurf(k,pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'Facecolor','blue','FaceAlpha',0.1)
    
    [k,av] = convhull(pointCloud);
    volume = av;
    counter

    min_x = min(pointCloud(:, 1));
    max_x = max(pointCloud(:, 1));
    min_y = min(pointCloud(:, 2));
    max_y = max(pointCloud(:, 2));
    min_z = min(pointCloud(:, 3));
    max_z = max(pointCloud(:, 3));
    
    

    % Display the ranges
    fprintf('Range in the x-direction: %.2f to %.2f\n', min_x, max_x);%, 'Distance is: ',xRadius);
    fprintf('Range in the y-direction: %.2f to %.2f\n', min_y, max_y);%, 'Distance is: ',yRadius);
    fprintf('Range in the z-direction: %.2f to %.2f\n', min_z, max_z);%, 'Distance is: ',zRadius);
    xRadius = (max_x - min_x)
    yRadius = (max_y - min_y)
    zRadius = (max_z - min_z)

    %profile off;
    %profile viewer;
end


function [matrix] = GetIK(robot,position,STEPS,guess,testpoint)

    Q = robot.getpos();
    Q = robot.ikcon(position,guess);
    matrix = jtraj(robot.getpos,Q,STEPS);
if nargin > 4
      TestPoint(robot,position)

end
end