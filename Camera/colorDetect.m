clear

minArea = 10000;

image = imread('cubes_topdown.png');

colourMask = createGreenMask(image);
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