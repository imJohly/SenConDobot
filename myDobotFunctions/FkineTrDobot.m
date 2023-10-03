function fkineTrDobot = FkineTrDobot(q,varargin)   
%MyFkineTr A custom very fast fkine calculator 

    %sets default base to the identiy matrix
    baseTr = eye(4);             

    %Assigns optional inputs if provideded by the user:
    if numel(varargin) >= 1
        baseTr = varargin{1};
    end

    %baseMatrix = baseTr * trotx(pi/2) * troty(pi/2);
    baseMatrix = baseTr;
    joint0to1Tr = GetJointToJointTr(q(1),   0.103+0.0362,   0,          -pi/2,      0);
    joint1to2Tr = GetJointToJointTr(q(2),   0,              0.135,      0,          -pi/2);
    joint2to3Tr = GetJointToJointTr(q(3),   0,              0.147,      0,          pi/2);
    joint3to4Tr = GetJointToJointTr(q(4),   0,              0.06,       pi/2,       -pi/2);
    joint4to5Tr = GetJointToJointTr(q(5),   -0.05,          0,          0,          pi);
    
    fkineTrDobot = baseMatrix * joint0to1Tr * joint1to2Tr * joint2to3Tr ...
       * joint3to4Tr * joint4to5Tr;

end

function tr = GetJointToJointTr(q,d,a,alpha,offset)
        tr = trotz(q+offset) * transl([0,0,d]) * transl([a,0,0]) * trotx(alpha);
    end
