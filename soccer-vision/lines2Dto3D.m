function lines3D = lines2Dto3D(lines, img, robotHeight, d, robotAngle, cameraAngle, focalLength)
    [r, ~] = size(lines);
    
    lines3D = zeros(r,6);
    
    for i = 1:r
        if(lines(i,1) == 1 && lines(i,2) == 1 && lines(i,3) == 1 && lines(i,4) == 2)
            continue
        end
        
        p1 = Point2f(lines(i,1), lines(i,2));
        p2 = Point2f(lines(i,3), lines(i,4));
        line = Line2f(lines(i,1), lines(i,2), lines(i,3), lines(i,4));
        
        % Check if the line has crossed the horizon, clip it at the horizon
        horizonY = tan(cameraAngle) * focalLength;
        [w, ~] = size(img);
        horizonLine = Line2f(w/2 - horizonY, pi/2);
        
        if(p1.y < w/2 - horizonY && p2.y < w/2 - horizonY)
            continue;
        end
        if(p1.y < w/2 - horizonY)
            inter =  Line2f.screenIntersection(horizonLine, line);
            p1.y = inter.y;
            p1.x = inter.x;
        end
        if(p2.y < w/2 - horizonY)
            inter = Line2f.screenIntersection(horizonLine, line);
            p2.y = inter.y;
            p2.x = inter.x;
        end

        p1_3d = point2Dto3D(p1, img, robotHeight, d, robotAngle, cameraAngle, focalLength); 
        p2_3d = point2Dto3D(p2, img, robotHeight, d, robotAngle, cameraAngle, focalLength);
        
        % Wrap into a big ass matrix
        l = Segment3f(p1_3d, p2_3d);
        lines3D(i,1) = l.p1.x;
        lines3D(i,2) = l.p1.y;
        lines3D(i,3) = l.p1.z;
        lines3D(i,4) = l.p2.x;
        lines3D(i,5) = l.p2.y;
        lines3D(i,6) = l.p2.z;
    end
end