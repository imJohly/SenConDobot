clear

image = imread('red2.jpg');

red = checkred(image);

se = strel('square', 20);
red_dilated = imdilate(red, se);

stats = regionprops(red_dilated, 'BoundingBox', 'Centroid')
box = stats.BoundingBox
centroid = stats.Centroid

imshow(image);
hold on;

rectangle('Position', box)
plot(round(centroid(1)), round(centroid(2)), 'b.', 'MarkerSize', 10);
% plot(50, 50, 'bo', 'MarkerSize', 10);
hold off;