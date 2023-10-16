%MDL_PLANAR3 Create model of a simple planar 3-link mechanism
%Scale value
a1 = 0.005;
a2 = 0.03;
a3 = 0.001;
q = zeros(1,3);
        
Gripper1 = SerialLink([
    Revolute('d', 0, 'a', a1, 'alpha', pi/2,'qlim', deg2rad([-60 60]), 'offset',-(pi)/2)
    Revolute('d', 0, 'a', a2, 'alpha', 0,   'qlim', deg2rad([-35 35]), 'offset',-pi/2)
    Revolute('d', 0, 'a', a3, 'alpha', 0,   'qlim', deg2rad([-5 5]), 'offset',-pi/7)
    ], ...
    'name', 'Griper 1');
%qz = [0 0 0];
Gripper1.model3d = 'DOBOT/Gripper1';
%Gripper1.links;

%Second gripper
Gripper2 = SerialLink([
    Revolute('d', 0, 'a', a1, 'alpha', pi/2, 'standard',   'qlim', deg2rad([-60 60]), 'offset',pi/2)
    Revolute('d', 0, 'a', a2, 'alpha', 0, 'standard',   'qlim', deg2rad([-35 35]), 'offset',-pi/2)
    Revolute('d', 0, 'a', a3, 'alpha', 0, 'standard',   'qlim', deg2rad([-5 5]), 'offset',-pi/7)
    ], ...
    'name', 'Griper 2');
qz = [0 0 0];

Gripper2.model3d = 'DOBOT/Gripper2';

% clf
% hold on
% newq = [0,0.5,0];
% DesiredColour = {'black','black','black','silver'} % Links {1,doent matter,2,3}
%         Gripper1.plot3d(CLOSE_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','color',DesiredColour);
%          Gripper2.plot(newq,'nowrist','notiles', 'noarrow','nojaxes','nobase');
% 
%         Gripper2.plot3d(CLOSE_GRIPPER_Q,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','color',DesiredColour);
% 
% % Gripper1.plot3d(newq,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','path','D:\OneDrive - UTS\University\Subjects\Year 3\Sem 2\41014 Sensors and Control\Git\SenConDobot\Gripper\Gripper1' );
% %  Gripper2.plot(newq,'nowrist','notiles', 'noarrow','nojaxes','nobase');
% % Gripper2.plot3d(newq,'delay',0.01,'noname','nowrist','notiles', 'noarrow','nojaxes','path','D:\OneDrive - UTS\University\Subjects\Year 3\Sem 2\41014 Sensors and Control\Git\SenConDobot\Gripper\Gripper2' );
% % 
% % 
% % 
% % RedCube = PlaceObject('RedCube.ply');
% % vertices = get(RedCube,'Vertices');
% % transformedVertices = [vertices,ones(size(vertices,1),1)] * transl(0,0,-0.05)';
% % set(RedCube,'Vertices',transformedVertices(:,1:3));
% 
% newq = [0,0.3,0.3];
% Gripper1.animate(newq);
% Gripper2.animate(newq);

