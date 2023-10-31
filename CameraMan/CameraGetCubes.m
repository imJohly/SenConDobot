function [objects] = CameraGetCubes(robot_translation, robot_rotation)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Must set robot frame, setting to zero as irrelevant to examples

    c = CameraMan(robot_translation, robot_rotation);
    
    % subscribers to camera topics
    camInfoSub = rossubscriber("/camera/aligned_depth_to_color/camera_info", "sensor_msgs/CameraInfo");
    colImgSub = rossubscriber("/camera/color/image_raw", "sensor_msgs/Image");
    depthImgSub = rossubscriber("/camera/aligned_depth_to_color/image_raw", "sensor_msgs/Image");

    c.intrinsics = camInfoSub.receive();
    c.colImg = colImgSub.receive();
    c.depthImg = depthImgSub.receive();
    objects = c.findObjectPosition();
    
    % display info
    for i = 1:height(objects)
        fprintf("%s Positions %i x:%1.2f y:%1.2f z:%1.2f \n", objects(i).col, i, objects(i).position(1), objects(i).position(2), objects(i).position(3));
    end
end