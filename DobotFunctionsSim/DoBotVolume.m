function [pointCloud,shp] = DoBotVolume(robot,loadingBar,plotPoints,boundryTrue)
    %profile clear;
    %profile on;
    
    stepDeg = 5;
    stepRads = deg2rad(stepDeg);
    qlim = robot.qlim;
    % Precalculate Point Cloud Size
    
    pointCloudeSize = 7481; %hard coded value as hard to do calculation when the limits are variable
    %prod(floor((qlim(1:3,2)-qlim(1:3,1))/stepRads + 1))
    pointCloud = zeros(pointCloudeSize,3);
    z = robot.base().t;
    counter = 1;
    if loadingBar
    progressbar = waitbar(0, 'Loading Point Cloud...');
    end
    for q1 = qlim(1,1):stepRads:qlim(1,2)
        for q2 = qlim(2,1):stepRads:qlim(2,2)
            for q3 = (pi/2 - q2):stepRads:qlim(3,2)

                        q4 = pi - q2 - q3;
                        q5 = 0;
                        q = [q1,q2,q3,q4,q5];

                        tr = robot.fkineUTS(q);
                        
                        
                        if tr(3,4) > (z(3) -0.001)
                            pointCloud(counter,:) = tr(1:3,4)';
                        
                        end

                        %pointCloud(counter,:) = tr(1:3,4)';

                        counter = counter + 1 ;

                        if loadingBar
                        waitbar(counter / pointCloudeSize, progressbar, sprintf('Loading Point Cloud... %d%%', round(counter / pointCloudeSize * 100)));
                        end

            end
        end
    end

    alpha = 0.06;
    shp = alphaShape(pointCloud, alpha);
    workingVolume = volume(shp)

    if plotPoints
        if boundryTrue
            % k = boundary(pointCloud);
            % trisurf(k,pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'Facecolor','red','FaceAlpha',0.1)

            plot(shp);

        else
            plot3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'r.');
        end
    end
    [k,av] = convhull(pointCloud);
    workSpaceVolume = av
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
    xDiameter = (max_x - min_x)
    yDiameter = (max_y - min_y)
    zDiameter = (max_z - min_z)
    if loadingBar
    close(progressbar);
    end
    %profile off;
    %profile viewer;
end