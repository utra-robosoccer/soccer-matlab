function poseActionList = findposeaction(waypoints, speed)
    % Speed in m/s

    [l,~] = size(waypoints);
    poseActionList = cell(l,1);
    for i = 1:l
        pose = Pose(waypoints(i,1),waypoints(i,2),waypoints(i,3),waypoints(i,4),waypoints(i,5));
        actionLabel = Command.ActionLabel.Forward;
        duration = 1;
        poseActionList{i} = PoseAction(pose, actionLabel, duration);        
    end
    
    for i = 2:l
        xdelta = poseActionList{i}.Pose.x - poseActionList{i-1}.Pose.x;
        ydelta = poseActionList{i}.Pose.y - poseActionList{i-1}.Pose.y;
        distance = sqrt(xdelta * xdelta + ydelta * ydelta);
        poseActionList{i}.Duration = distance / speed;
    end
end