% view camera
clear

rosshutdown
rosinit

% Subscribes to Camera Info
infoSub = rossubscriber("/camera/depth/camera_info");

% Subscribes to Color and Depth data from camera
depthCamSub = rossubscriber("/camera/depth/image_rect_raw", "sensor_msgs/Image");
colourCamSub = rossubscriber("/camera/color/image_raw", "sensor_msgs/Image");

infoMsg = infoSub.receive();

K = reshape(infoMsg.K, [3, 3])';

% Extract the camera intrinsic parameters
focalLength = [K(1, 1), K(2, 2)]; % Focal length in y-direction
principalPoint = [K(1, 3), K(2, 3)]; % Principal point y-coordinate
imageSize = [double(infoMsg.Height), double(infoMsg.Width)];
intrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);
depthScaleFactor = 2;
maxCameraDepth   = 10;

while true
    colourImgMsg = colourCamSub.receive(5); 
    colourImg = readImage(colourImgMsg);
    positions = detectColor(colourImg, 'r');
    
    depthImgMsg = depthCamSub.receive(5);
    depthImg = readImage(depthImgMsg);

    % disp([round(positions(1)), round(positions(2))])
    if ~isempty(positions)
        imgX = round(positions(1));
        imgY = round(positions(2));
        disp('IMAGE XY')
        disp([imgX, imgY])
        
        depth = double(depthImg(imgY, imgX));
        
        x = (imgX - intrinsics.PrincipalPoint(1)) * depth / intrinsics.FocalLength(1);
        y = (imgY - intrinsics.PrincipalPoint(2)) * depth / intrinsics.FocalLength(2);
        z = depth;
        
        disp('3D Position')
        disp([x/1000, y/1000, z/1000]);
    end

    drawnow
end

% Using red_position_test.jpg
% red is at x = -100~70mm, y = 0mm z = 350mm