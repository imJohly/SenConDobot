function [r,GripperOpenMatrix] = PlotRobotAndGripper(baseTr,gripperMode,gripperSteps)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here 
% Simulation Robot

    r = Dobot(baseTr);
    defaultQ = r.RealQToModelQ(r.defaultRealQ);
    r.model.animate(defaultQ);
    
    hold on
    
    
    mdl_gripper;
    
    OPEN_GRIPPER_Q = [0 0.61 0];
    CLOSE_GRIPPER_Q = [0,0.5,0];

    
    %Places a DH model gripper into the environment
    if gripperMode.DH == true

            Gripper1.plot(q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','nobase','noshadow');
            Gripper2.plot(q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','nobase','noshadow');

    end

    %Places a graphical model gripper into the environment
    if gripperMode.Model == true

            DesiredColour = {'black','black','black','silver'}; % Links {1,doent matter,2,3}

            Gripper1.plot3d(OPEN_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','color',DesiredColour,'path',what('Gripper1').path);
            Gripper2.plot3d(OPEN_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','color',DesiredColour,'path',what('Gripper2').path);

    end
    
    %Set Gripper on robot
            gripperLoc = DobotFkReal(r,defaultQ);
            Gripper1.base = gripperLoc * rpy2tr(0,0,pi);
            Gripper2.base = gripperLoc * rpy2tr(0,0,pi);
            Gripper1.animate(Gripper1.getpos);
            Gripper2.animate(Gripper2.getpos);
    
    % Set Gripper open and close trajectories
    GripperOpenMatrix = jtraj(CLOSE_GRIPPER_Q,OPEN_GRIPPER_Q,gripperSteps);


       
    %Placing in the floor
    floor = surf([-0.6,-0.6;0.5,0.5] ,[-0.6,0.6;-0.6,0.6] ,[0,0;0,0]...
    ,'CData',imread('Floor.jpg') ,'FaceColor','texturemap');
    rotate(floor,[0,0,1],180);

end