function [volume] = AidanVolume(robot,boundryTrue)
    %profile clear;
    %profile on;
    
    stepDeg = 10;
    stepRads = deg2rad(stepDeg);
    qlim = robot.qlim;
    % Precalculate Point Cloud Size
    pointCloudeSize = prod(floor((qlim(1:4,2)-qlim(1:4,1))/stepRads + 1));
    pointCloud = zeros(pointCloudeSize,3);
    z = robot.base().t;
    counter = 1;
    
    for q1 = qlim(1,1):stepRads:qlim(1,2)
        for q2 = qlim(2,1):stepRads:qlim(2,2)
            for q3 = qlim(3,1):stepRads:qlim(3,2)
                for q4 = qlim(4,1):stepRads:qlim(4,2)
                    %for q5 = qlim(5,1):stepRads:qlim(5,2)

                        %q2=0;
                        %q3 = 0;
                        %q4 = 0;
                        q5 = 0;
                        %q6 = 0;
                        q = [q1,q2,q3,q4,q5];

                        tr = robot.fkineUTS(q);
                        
                        
                        if tr(3,4) > (z(3) -0.001)
                            pointCloud(counter,:) = tr(1:3,4)';
                        
                        end

                        %pointCloud(counter,:) = tr(1:3,4)';

                        counter = counter + 1 ;

                    %end
                end
            end
        end
    end
    
    if boundryTrue
        k = boundary(pointCloud);
        trisurf(k,pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'Facecolor','red','FaceAlpha',0.1)
    
    else
        plot3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'r.');
    end
    
    [k,av] = convhull(pointCloud);
    volume = av;
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

    %profile off;
    %profile viewer;
end