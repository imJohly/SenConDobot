%MDL_PLANAR3 Create model of a simple planar 3-link mechanism
%Scale value
a1 = 0.015;
a2 = 0.02;
a3 = 0.03;
q = zeros(1,3);
        
Gripper1 = SerialLink([
    Revolute('d', 0, 'a', a1, 'alpha', pi/2,'qlim', deg2rad([-60 60]), 'offset',-(pi)/2)
    Revolute('d', 0, 'a', a2, 'alpha', 0,   'qlim', deg2rad([-60 60]), 'offset',-pi/2)
    Revolute('d', 0, 'a', a3, 'alpha', 0,   'qlim', deg2rad([-60 60]), 'offset',-pi/7)
    ], ...
    'name', 'Griper 1');
%qz = [0 0 0];


%Second gripper
Gripper2 = SerialLink([
    Revolute('d', 0, 'a', a1, 'alpha', pi/2, 'standard',   'qlim', deg2rad([-60 60]), 'offset',pi/2)
    Revolute('d', 0, 'a', a2, 'alpha', 0, 'standard',   'qlim', deg2rad([-60 60]), 'offset',-pi/2)
    Revolute('d', 0, 'a', a3, 'alpha', 0, 'standard',   'qlim', deg2rad([-60 60]), 'offset',-pi/7)
    ], ...
    'name', 'Griper 2');
qz = [0 0 0];



