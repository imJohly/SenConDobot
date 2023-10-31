clear

rosshutdown
rosinit

% Must set robot frame, setting to zero as irrelevant to examples
robot_translation = [-0.025, 0.32, -0.27 + 0.05];
rot = rpy2tr(pi, 0, pi);
robot_rotation = rot(1:3, 1:3);

c = CameraMan(robot_translation, robot_rotation);

% subscribers to camera topics
camInfoSub = rossubscriber("/camera/depth/camera_info", "sensor_msgs/CameraInfo");
colImgSub = rossubscriber("/camera/color/image_raw", "sensor_msgs/Image");
depthImgSub = rossubscriber("/camera/aligned_depth_to_color/image_raw", "sensor_msgs/Image");

% EXAMPLE: REAL TIME
while true
    [c.intrinsics, c.colImg, c.depthImg] = updateCamera(camInfoSub, colImgSub, depthImgSub);
    objects = c.findObjectPosition();

    % display info
    for i = 1:height(objects)
        fprintf("%s Positions %i x:%1.2f y:%1.2f z:%1.2f \n", objects(i).col, i, objects(i).position(1), objects(i).position(2), objects(i).position(3));
    end
    
    pause(0.1);
end

% % EXAMPLE: SNAP SHOT
% [c.intrinsics, c.colImg, c.depthImg] = updateCamera(camInfoSub, colImgSub, depthImgSub);
% objects = c.findObjectPosition();

% % display info
% for i = 1:height(objects)
%     fprintf("%s Positions %i x:%1.2f y:%1.2f z:%1.2f \n", objects(i).col, i, objects(i).position(1), objects(i).position(2), objects(i).position(3));
% end

rosshutdown

function [info, col, depth] = updateCamera(camInfoSub, colImgSub, depthImgSub)
    %updateCamera receives new ROS messages and updates CameraMan object
     
    info = camInfoSub.receive();
    col = colImgSub.receive();
    depth = depthImgSub.receive();
end