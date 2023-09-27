function [xyzPos] = RandCoordinates(limits)

%RandCoordinates Gets random coordinates within specified limits
    
    % Generate random numbers within their respective limits
    x = limits(1) + (limits(2) - limits(1)) * rand;
    y = limits(3) + (limits(3) - limits(3)) * rand;
    z = limits(5) + (limits(6) - limits(5)) * rand;
    
    xyzPos = [x,y,z];

end