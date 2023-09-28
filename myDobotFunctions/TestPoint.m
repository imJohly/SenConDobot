function isInside = TestPoint(pointCloud, queryPoint)

    alpha = 0.06;
    shp = alphaShape(pointCloud, alpha);
    %plot(shp);

    isInside = inShape(shp,queryPoint(1,4),queryPoint(2,4),queryPoint(3,4));

    if ~isInside
        fprintf('The query point is outside the range of the robot\n');
    end
end
