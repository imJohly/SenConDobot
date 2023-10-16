function [x, y, z] = pixel2Position(pixelPosition, depthImage, cameraIntrinsics)

    depth = double(depthImage(pixelPosition(2), pixelPosition(1)));

    x = (pixelPosition(1) - cameraIntrinsics.PrincipalPoint(1)) * depth / cameraIntrinsics.FocalLength(1);
    y = (pixelPosition(2) - cameraIntrinsics.PrincipalPoint(2)) * depth / cameraIntrinsics.FocalLength(2);
    z = depth;
end