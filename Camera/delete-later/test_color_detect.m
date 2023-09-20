clear

image = imread('red.jpg');

red = image(:,:,1);

redHueThreshold = 190;
redMask = red >= redHueThreshold;

[rows, columns] = find(redMask > 0);

centroidX = median(rows);
centroidY = median(columns);

imshow(image);
hold on;
plot(centroidX, centroidY, 'ro', 'MarkerSize', 10);
hold off;