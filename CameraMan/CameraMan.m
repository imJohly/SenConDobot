classdef CameraMan
    %CAMERAMAN class
    %   The CameraMan class contains functions for interfacing with
    %   a realsense2 camera.

    properties
        objPositions = [];                          % Stores detected object positions

        intrinsics = [];                            % Stores camera intrinsics
        colImg = [];                                % Stores colour image from camera
        depthImg = [];                              % Stores depth image from camera 

        robotTrans = [0, 0, 0];               % Robot Translation ... from camera/origin
        robotRot = [1, 0, 0; 0, 1, 0; 0, 0, 1];     % Robot Rotation ... from camera/origin
    end

    methods
        function obj = CameraMan(robot_trans, robot_rot)
            arguments
                robot_trans (1, 3) double
                robot_rot (3, 3) double
            end
            %CameraMan Constructs an instance of this class
            %   Make sure ROS is initialised before using this class

            obj.robotTrans = robot_trans
            obj.robotRot = robot_rot
        end

        function obj = set.intrinsics(obj, in)    
            %cameraInfoCallback Setter function for camera intrinsics
            %   Extracts intrinsic parameters from the depth camera and
            %   stores them as class properties.

            % Reshape camera intrinsic matrix
            K = reshape(in.K, [3, 3])';

            % Extract the camera intrinsic parameters
            focalLength     = [K(1, 1), K(2, 2)];
            principalPoint  = [K(1, 3), K(2, 3)];
            imageSize       = [double(in.Height), double(in.Width)];
            
            % store in class properties
            obj.intrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);
        end

        function obj = set.colImg(obj, in)
            %colourImageCallback Setter function for incoming colour image messages
            obj.colImg = readImage(in);
        end

        function obj = set.depthImg(obj, in)
            %depthImageCallback Setter function for incoming depth image messages
            obj.depthImg = readImage(in);
        end

        function positions = findObjectPosition(obj)
            %findObjectPosition Finds RGB object's relative 3D position
            %   Returns an array of structs for object colour and position

            positions = [];

            % Figure
            imshow(obj.colImg);
            hold on;

            % Loop to check for RGB
            for c = 1:3

                check = '';
                switch c
                    case 1
                        check = 'r';
                    case 2
                        check = 'g';
                    case 3
                        check = 'b';
                end

                % detect RGB objects
                pixelPos = obj.colourDetect(check);

                for i = 1:height(pixelPos)
                    if ~isempty(pixelPos)
                        
                        % Get pixel coordinates
                        imgX = round(pixelPos(i, 1));
                        imgY = round(pixelPos(i, 2));

                        % Convert pixel coords to 3D position
                        thisPosition = obj.pixel2Position([imgX, imgY]);
                        thisTransform = eye(4);
                        thisTransform(1, 4) = thisPosition(1);
                        thisTransform(2, 4) = thisPosition(2);
                        thisTransform(3, 4) = thisPosition(3);

                        classyPosition = struct('col', 'position'); % A catagorised structure for positions
                        classyPosition.col = check;
                        classyPosition.position = obj.convert2RobotFrame(thisTransform);
                        

                        positions = [positions; classyPosition];
                    end
                end
            end
        end
    end

    methods (Access = private)
        function positions = colourDetect(obj, colToDetect, minArea)
            arguments
                obj
                colToDetect (1, 1) string
                % debugging   (1, 1) boolean = false
                minArea     (1, 1) int32   = 1000
            end
            %colourDetect Gets an image from cameraSub and detects the colour
            %   This function gets an image from cameraSub and detects the
            %   colour chosen in parameter colToDetect.
            % 
            %   Returns an array of the pixel position of the coloured region.

            % Returns nothing is there's no colour image
            if isempty(obj.colImg)
                positions = [];
                disp('no image');
                return
            end
            
            % create a colour mask depending on which colour needs to be detected
            img = obj.colImg;
            colourMask = [];
            switch colToDetect
                case 'r'
                    colourMask = obj.createRedMask(img);
                case 'g'
                    colourMask = obj.createGreenMask(img);
                case 'b'
                    colourMask = obj.createBlueMask(img);
            end

            % dilate region to merge noisy regions
            se = strel('square', 20);
            colourDilated = imdilate(colourMask, se);

            % calculate colour regions
            colourRegions = regionprops(colourDilated, 'Area', 'Centroid', 'BoundingBox');
            
            
            % loop through regions and keep regions greater than minimum area.
            centroids = [];
            for i = 1:numel(colourRegions)
                area = colourRegions(i).Area;
                if area >= minArea
                    % If the region meets the area threshold, save its centroid
                    centroids = [centroids; colourRegions(i).Centroid];
                    rectangle('Position', colourRegions(i).BoundingBox, 'EdgeColor', 'r')
                    plot(colourRegions(i).Centroid(1), colourRegions(i).Centroid(2), 'b.', 'MarkerSize', 10);
                end
            end

            positions = centroids;
        end

        function position = convert2RobotFrame(obj, rel_transform)
            % arguments
            %     obj
            %     rel_transform (4, 4) double
            % end
            %convert2RobotFRame converts rel_transform to robot frame
            %   This function takes a relative transform and converts its to
            %   the robot transform frame.
            % 
            %   This done simply through b * inv(A),
            %   where:
            %       - A is the source frame
            %       - b is the target frame
            % 
            %   rel_transform and robot_frame is in the form of
            %       | 1 0 0 x |
            %       | 0 1 0 y |
            %       | 0 0 1 z |
            %       | 0 0 0 1 |
            % 
            %   Returns a vector array of the transformed position

            obj.robotRot
            obj.robotTrans

            robot_frame = eye(4);                       % assume default rotation
            robot_frame(1:3, 1:3) = obj.robotRot;
            robot_frame(1:3, 4) = obj.robotTrans;
            
            rel_transform
            robot_frame

            tf = rel_transform / robot_frame;
            position = tf(1:3, 4);
        end

        function position = pixel2Position(obj, pixelPosition)
            arguments
                obj
                pixelPosition (1, 2) double
            end
            %pixel2Position Converts a given pixelPosition into a 3D point relative to the camera
            %   This function takes in a pixel position based on the colour
            %   image from the camera and converts it to a 3D translation
            %   relative to the camera.
            % 
            %   The main formulas are,
            %   x = (ix - cx) * (z / fx)
            %   y = (iy - cy) * (z / fy)
            % 
            %   Returns a vector array of the calculated position

            % Returns nothing is there's no depth image
            if isempty(obj.depthImg)
                disp('WARNING! No depth image found!')
                position = [];
                return
            end

            ix = pixelPosition(1);
            iy = pixelPosition(2);

            % Grab depth value from pixel point
            depth = double(obj.depthImg(iy, ix));
            
            % Calculate the 3d relative position, scaled to metres
            x = (ix - obj.intrinsics.PrincipalPoint(1)) * depth / obj.intrinsics.FocalLength(1) / 1000;
            y = (iy - obj.intrinsics.PrincipalPoint(2)) * depth / obj.intrinsics.FocalLength(2) / 1000;
            z = depth / 1000;

            position = [x, y, z];
        end
    end

    methods (Static)
        function [BW,maskedRGBImage] = createRedMask(RGB)
            %createMask  Threshold RGB image using auto-generated code from colorThresholder app.
            %  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
            %  auto-generated code from the colorThresholder app. The colorspace and
            %  range for each channel of the colorspace were set within the app. The
            %  segmentation mask is returned in BW, and a composite of the mask and
            %  original RGB images is returned in maskedRGBImage.
            
            % Auto-generated by colorThresholder app on 15-Oct-2023
            %------------------------------------------------------
            
            
            % Convert RGB image to chosen color space
            I = rgb2lab(RGB);
            
            % Define thresholds for channel 1 based on histogram settings
            channel1Min = 1.623;
            channel1Max = 75.853;
            
            % Define thresholds for channel 2 based on histogram settings
            channel2Min = 27.705;
            channel2Max = 73.171;
            
            % Define thresholds for channel 3 based on histogram settings
            channel3Min = -36.452;
            channel3Max = 36.236;
            
            % Create mask based on chosen histogram thresholds
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            BW = sliderBW;
            
            % Initialize output masked image based on input image.
            maskedRGBImage = RGB;
            
            % Set background pixels where BW is false to zero.
            maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
            
        end

        function [BW,maskedRGBImage] = createGreenMask(RGB)
            %createMask  Threshold RGB image using auto-generated code from colorThresholder app.
            %  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
            %  auto-generated code from the colorThresholder app. The colorspace and
            %  range for each channel of the colorspace were set within the app. The
            %  segmentation mask is returned in BW, and a composite of the mask and
            %  original RGB images is returned in maskedRGBImage.
            
            % Auto-generated by colorThresholder app on 15-Oct-2023
            %------------------------------------------------------
            
            
            % Convert RGB image to chosen color space
            I = rgb2lab(RGB);
            
            % Define thresholds for channel 1 based on histogram settings
            channel1Min = 2.826;
            channel1Max = 99.901;
            
            % Define thresholds for channel 2 based on histogram settings
            channel2Min = -57.712;
            channel2Max = -17.433;
            
            % Define thresholds for channel 3 based on histogram settings
            channel3Min = -62.724;
            channel3Max = 54.674;
            
            % Create mask based on chosen histogram thresholds
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            BW = sliderBW;
            
            % Initialize output masked image based on input image.
            maskedRGBImage = RGB;
            
            % Set background pixels where BW is false to zero.
            maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
            
        end
        
        function [BW,maskedRGBImage] = createBlueMask(RGB)
            %createMask  Threshold RGB image using auto-generated code from colorThresholder app.
            %  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
            %  auto-generated code from the colorThresholder app. The colorspace and
            %  range for each channel of the colorspace were set within the app. The
            %  segmentation mask is returned in BW, and a composite of the mask and
            %  original RGB images is returned in maskedRGBImage.
            
            % Auto-generated by colorThresholder app on 15-Oct-2023
            %------------------------------------------------------
            
            
            % Convert RGB image to chosen color space
            I = rgb2lab(RGB);
            
            % Define thresholds for channel 1 based on histogram settings
            channel1Min = 1.623;
            channel1Max = 98.770;
            
            % Define thresholds for channel 2 based on histogram settings
            channel2Min = -44.602;
            channel2Max = 73.171;
            
            % Define thresholds for channel 3 based on histogram settings
            channel3Min = -36.452;
            channel3Max = -19.149;
            
            % Create mask based on chosen histogram thresholds
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            BW = sliderBW;
            
            % Initialize output masked image based on input image.
            maskedRGBImage = RGB;
            
            % Set background pixels where BW is false to zero.
            maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
            
        end
            
    end
end