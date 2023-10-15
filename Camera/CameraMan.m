classdef CameraMan
    %CAMERAMAN class
    %   The CameraMan class contains functions for interfacing with
    %   a realsense2 camera.

    properties
        cameraSub
        snap
    end

    methods
        function obj = CameraMan(cameraTopic)
            %CameraMan Construct an instance of this class

            % Subscribe to camera topic
            obj.cameraSub = rossubscriber(cameraTopic, "sensor_msgs/Image", @laserScanCallback);
        end

        function obj = laserScanCallback(obj, msg)
            %laserScanCallback Callback function for incoming laserscans
            obj.snap = msg.data;
        end

        function positions = colourDetect(obj, colToDetect)
            %colourDetect Gets an image from cameraSub and detects the colour
            %   This function gets an image from cameraSub and detects the
            %   colour chosen in parameter colToDetect. It returns an array of the
            %   pixel position of the coloured region.

            % check if image exists
            if isempty(obj.snap)
                positions = col;
                return
            end

            img = imread(obj.snap);

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
    end
end