clear

rosshutdown
rosinit

c = CameraMan();

% subscribers to camera topics
camInfoSub = rossubscriber("/camera/depth/camera_info", "sensor_msgs/CameraInfo");
colImgSub = rossubscriber("/camera/color/image_raw", "sensor_msgs/Image");
depthImgSub = rossubscriber("/camera/aligned_depth_to_color/image_raw", "sensor_msgs/Image");

% % EXAMPLE: REAL TIME
% while true
%     [c.intrinsics, c.colImg, c.depthImg] = update_camera(camInfoSub, colImgSub, depthImgSub);
%     objects = c.findObjectPosition();
    
%     for i = 1:height(objects)
%         fprintf("%s Positions %i x:%1.2f y:%1.2f z:%1.2f \n", objects(i).col, i, objects(i).position(1), objects(i).position(2), objects(i).position(3));
%     end
    
%     pause(0.1);
% end

% EXAMPLE: SNAP SHOT
[c.intrinsics, c.colImg, c.depthImg] = update_camera(camInfoSub, colImgSub, depthImgSub);
objects = c.findObjectPosition();

for i = 1:height(objects)
    fprintf("%s Positions %i x:%1.2f y:%1.2f z:%1.2f \n", objects(i).col, i, objects(i).position(1), objects(i).position(2), objects(i).position(3));
end

rosshutdown

function [info, col, depth] = update_camera(camInfoSub, colImgSub, depthImgSub)
    info = camInfoSub.receive();
    col = colImgSub.receive();
    depth = depthImgSub.receive();
end