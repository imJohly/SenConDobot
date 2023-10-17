function isInside = TestPoint(pointCloud, queryPoint,shp)

    isInside = inShape(shp,queryPoint(1,4),queryPoint(2,4),queryPoint(3,4));

    if ~isInside
        fprintf('The query point is outside the range of the robot\n');
    end

end
