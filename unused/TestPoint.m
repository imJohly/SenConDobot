function isInside = TestPoint(queryPoint,shp)
% Takes the point you are testing and an alpha shape 
% returns true if the point is inside the alpha shape

    isInside = inShape(shp,queryPoint(1,4),queryPoint(2,4),queryPoint(3,4));

    if ~isInside
        fprintf('The query point is outside the range of the robot\n');
    end

end



