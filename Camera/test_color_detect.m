clear

% infoSub = rossubscriber("/camera/depth/camera_info");
% infoMsg = infoSub.receive();

% K = reshape(infoMsg.K, [3, 3])';

image = imread('red_position_test.jpg');

position = detectColor(image, 'r');

disp(position);

depth = 350;

fx = 426.821899414063;
fy = 426.821899414063;
cx = 423.220733642578;
cy = 236.632736206055;

x = (position(1) - cx) * depth / fx;
y = (position(2) - cy) * depth / fy;
z = depth;

disp([x, y, z]);