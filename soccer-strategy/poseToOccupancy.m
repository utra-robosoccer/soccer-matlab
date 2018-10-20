function [coord] = posetooccupancy(pose)
    % Map size is 9 x 6 meters where x is 6 meters and y is 9 meters
    xPose = pose.x + 3;
    yPose = pose.y + 4.5;
    
    xCor = xPose * 10;
    yCor = yPose * 10; % Use decimeters
    
    if xCor < 0
        xCor = 0;
    end
    if xCor > 59
        xCor = 59;
    end
    if yCor < 0
        yCor = 0;
    end
    if yCor > 89
        yCor = 89;
    end
    
    xCor = xCor + 1;
    yCor = yCor + 1;
    
    coord = [xCor yCor];
end