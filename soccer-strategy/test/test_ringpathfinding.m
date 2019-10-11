% Create a robot
robot = Navigation.Robot(Pose(0,0,0,0,0), Navigation.EntityType.Self, 0.05);

radius = 5;
degree = 10;

% Degrees to Radian
angle = degree*2*pi/360;

% Create Map
map = Navigation.Map(radius*2+1, radius*2+1, 0.05);
map.objects = {robot}; 

% Total Paths 
paths = floor(360/degree);

% Generate trajectories for each angle increment (i)
for i = 1:paths
    endPose = Pose(radius*cos(i*angle), radius*sin(i*angle), 0, i*angle, 0); 
    trajectory = map.FindTrajectory(robot.pose, endPose, robot.speed);
    trajectories(i) = trajectory;
end

% Append 8 columns of zeros to the transpose of Trajectory.Angles
jointangles = cell(paths, 2);
for i = 1:length(trajectories)
    angles = trajectories(i).angles;
    jointangles(i,:) = {degree*i, ...
        [angles', zeros(trajectories(i).totalsteps, 8)]};
end

% Export the joint angles for each trajectory to a csv file
for i = 1:length(jointangles)
    % If angle = 2*pi make it store as 0
    if jointangles{i,1} == 360
        filename = "ringtrajectories/radius" + string(radius) + "angle0.csv";
    else 
        filename = "ringtrajectories/radius" + string(radius) + "angle" + ...
            string(jointangles{i,1}) + ".csv";
    end
    csvwrite(filename, jointangles{i, 2});
end




