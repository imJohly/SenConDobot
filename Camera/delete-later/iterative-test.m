clear

image = imread('red.jpg');

red = image(:,:,1);

redHueThreshold = 190;
redMask = red >= redHueThreshold;

[rows, columns] = find(redMask > 0);

initialRegionSize = 100;
bestCentroidX = 0;
bestCentroidY = 0;

for i = 1:3
    bestCentroidX = median(rows);
    bestCentroidY = median(columns);

    x1 = max(1, round(bestCentroidX - initialRegionSize/2));
    x2 = min(size(image, 2), round(bestCentroidX + initialRegionSize/2));
    y1 = max(1, round(bestCentroidY - initialRegionSize/2));
    y2 = min(size(image, 1), round(bestCentroidY + initialRegionSize/2));

    redMask = redMask(y1:y2, x1:x2);
end

imshow(image);
hold on;
plot(centroidX, centroidY, 'ro', 'MarkerSize', 10);
hold off;