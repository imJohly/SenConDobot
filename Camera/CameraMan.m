classdef CameraMan
    %CAMERAMAN class
    %   The CameraMan class contains functions for interfacing with
    %   a realsense2 camera.

    properties
        % Depth Camera Info
        camInfoSub
        intrinsics

        % Colour image
        colImgSub
        colourImg
        
        % Depth image
        depthImgSub
        depthImg
    end

    methods
        function obj = CameraMan()
            %CameraMan Construct an instance of this class
            %   Ensure ros is initialised before instantiating class

            % Subscribe to camera topics
            obj.camInfoSub = rossubscriber("/camera/depth/camera_info", "sensor_msgs/Camera_Info", @cameraInfoCallback);
            obj.colImgSub = rossubscriber("/camera/color/image_raw", "sensor_msgs/Image", @colourImageCallback);
            obj.depthImgSub = rossubscriber("/camera/depth/image_rect_raw", "sensor_msgs/Image", @depthImageCallback);

            obj.start_camera()
        end

        function obj = cameraInfoCallback(obj, msg)
            %cameraInfoCallback Callback function for rostopic /camera/depth/camera_info
            %   Extracts intrinsic parameters from the depth camera and
            %   stores them as class properties.

            % Reshape camera intrinsic matrix
            K = reshape(msg.K, [3, 3])';

            % Extract the camera intrinsic parameters
            focalLength = [K(1, 1), K(2, 2)]; % Focal length in y-direction
            principalPoint = [K(1, 3), K(2, 3)]; % Principal point y-coordinate
            imageSize = [double(infoMsg.Height), double(infoMsg.Width)];
            
            % store in class properties
            obj.intrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);
        end

        function obj = colourImageCallback(obj, msg)
            %colourImageCallback Callback function for incoming colour images
            obj.colourImg = msg;
        end

        function obj = depthImageCallback(obj, msg)
            %depthImageCallback Callback function for incoming depth images
            obj.depthImg = msg;
        end

        function obj = start_camera(obj)
            while true
                % detect RGB objects
                positions = detectColor(obj.colourImg);
                imshow(obj.colourImg);

                if ~isempty(positions)
                    imgX = round(positions(1));
                    imgY = round(positions(2));

                    [x, y, z] = obj.pixel2Position([imgX, imgY]);

                    disp([x, y, z]);
                end

                drawnow
            end
        end

        function positions = colourDetect(obj, colToDetect)
            %colourDetect Gets an image from cameraSub and detects the colour
            %   This function gets an image from cameraSub and detects the
            %   colour chosen in parameter colToDetect. It returns an array of the
            %   pixel position of the coloured region.

            % check if image exists
            if isempty(obj.colourImg)
                positions = col;
                return
            end

            img = imread(obj.colourImg);

            colourMask = [];

            % create a colour mask depending on which colour needs to be detected
            switch colToDetect
                case 'r'
                    colourMask = createRedMask(img);
                case 'g'
                    colourMask = createGreenMask(img);
                case 'b'
                    colourMask = createBlueMask(img);
            end

            % dilate region to improve region area
            se = strel('square', 20);
            colourDilated = imdilate(colourMask, se);

            % calculate colour regions
            colourRegions = regionprops(colourDilated, 'Area', 'Centroid', 'BoundingBox');

            centroids = [];

            % loop through regions and keep regions greater than minimum area.
            for i = 1:numel(stats)
                area = stats(i).Area;
                if area >= minArea
                    % If the region meets the area threshold, save its centroid
                    centroids = [centroids; colourRegions(i).Centroid];
                end
            end

            positions = centroids;
        end

        function [x, y, z] = pixel2Position(obj, pixelPosition)
            %pixel2Position Converts a given pixelPosition into a 3D point relative to the camera

            ix = pixelPosition(1);
            iy = pixelPosition(2);

            % Grab depth value from pixel point
            depth = double(depthImage(ix, iy));
        
            % Calculate the 3d relative position
            x = (ix - obj.intrinsics.PrincipalPoint(1)) * depth / obj.intrinsics.FocalLength(1);
            y = (iy - obj.intrinsics.PrincipalPoint(2)) * depth / obj.intrinsics.FocalLength(2);
            z = depth;
        end
    end
end