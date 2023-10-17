function [xyzrPos] = RandCoordinates(limits)

%RandCoordinates Gets random coordinates within specified limits
    
    % Generate random numbers within their respective limits
    x = limits(1) + (limits(2) - limits(1)) * rand;
    y = limits(3) + (limits(4) - limits(3)) * rand;
    z = limits(5) + (limits(6) - limits(5)) * rand;
    r = limits(7) + (limits(8) - limits(7)) * rand;
    
    xyzrPos = [x,y,z,r];

end