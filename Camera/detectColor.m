function positions = detectColor(image, colToDetect)
    minArea = 1000;
    
    % create a colour mask depending on which colour needs to be detected
    switch colToDetect
        case 'r'
            colourMask = createRedMask(image);
        case 'g'
            colourMask = createGreenMask(image);
        case 'b'
            colourMask = createBlueMask(image);
    end

    se = strel('square', 20);
    colourDilated = imdilate(colourMask, se);
    
    stats = regionprops(colourDilated, 'Area', 'Centroid', 'BoundingBox');
    
    % Initialize an empty array to store centroids
    centroids = [];
    
    % Show image and hold
    imshow(image);
    hold on;
    
    % Loop through the regions and filter by area
    for i = 1:numel(stats)
        area = stats(i).Area;
        if area >= minArea
            % If the region meets the area threshold, save its centroid
            centroids = [centroids; stats(i).Centroid];
            rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'r')
            plot(stats(i).Centroid(1), stats(i).Centroid(2), 'b.', 'MarkerSize', 10);
        end
    end
    
    hold off;

    positions = centroids;
end