
% Create a robot
robot = Navigation.Robot(Pose(0,0,0,0,0), Navigation.EntityType.Self, 0.10);

% Destination position
endPose = Pose(2.5,2.5,0,0,0);

% Add objstacles
obs1 = Navigation.Entity(Pose(1.3,1.3,0,0,0), Navigation.EntityType.Friendly);
obs2 = Navigation.Entity(Pose(-1.7,1.7,0,0,0), Navigation.EntityType.Friendly);
obs3 = Navigation.Entity(Pose(1.5,-1.5,0,0,0), Navigation.EntityType.Friendly);

map = Navigation.Map(9, 6, 0.05);
map.objects = {robot, obs1, obs2, obs3};
trajectory = map.FindTrajectory(robot.pose, endPose, robot.speed);

% Draw the map and path
map.Draw();
hold on;
trajectory.DrawPath();
figure;
trajectory.PlotAngles();
trajectory.AverageSpeed();
robot.SimulationTrajectory(trajectory);
