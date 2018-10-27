function point3f = point2Dto3D(point2f, img, robotHeight, d, robotAngle, cameraAngle, focalLength)
    [h, w] = size(img);
    
    % Need to cut off the screen based on the angle chosen
    x = double(w / 2 - point2f.x);
    y = double(h / 2 - point2f.y);
    
    angle1 = atan2(y, focalLength);
    angle2 = (pi / 2 - cameraAngle) + angle1;
    dprime = tan(angle2) * robotHeight;
    xdelta = dprime - d;
    
    z1 = sqrt(((d + xdelta) ^ 2) + robotHeight ^ 2);
    
    ydelta = x / focalLength * z1;
    
    x1 = d + xdelta;
    y1 = ydelta;
    
    % Rotate based on the angle of the robot
    px = x1 * cos(robotAngle + pi/2) - y1 * sin(robotAngle + pi/2);
    py = x1 * sin(robotAngle + pi/2) + y1 * cos(robotAngle + pi/2);
    pz = 0;
    
    point3f = Point3f(px, py, pz);
end