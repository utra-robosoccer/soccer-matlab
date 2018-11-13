close all; clear; clc;

% Create a robot
robot = Navigation.Robot(Pose(0,0,0,0,0), Navigation.EntityType.Self, 0.05);

% Destination position
endPose = Pose(2.5,2.5,0,0,0);

% Add obstacles
obs1 = Navigation.Entity(Pose(1.3,1.3,0,0,0), Navigation.EntityType.Friendly);
obs2 = Navigation.Entity(Pose(-1.7,1.7,0,0,0), Navigation.EntityType.Friendly);
obs3 = Navigation.Entity(Pose(1.5,-1.5,0,0,0), Navigation.EntityType.Friendly);

map = Navigation.Map(9, 6, 0.05);
map.objects = {robot, obs1, obs2, obs3};
trajectory = map.FindTrajectory(robot.pose, endPose, robot.speed);

% Draw the angles
figure;
trajectory.PlotAngles();

% Get the actual trajectory
trajectory.AverageSpeed();
truepath = robot.SimulationTrajectory(trajectory);

% Draw ground truth simulation position
f = figure('pos',[10 10 900 600]);
ax = axes('Parent',f,'position',[0.13 0.29  0.77 0.64]);
hold on;
grid minor;
map.Draw();
trajectory.DrawPath();
plot(truepath(:,1), truepath(:,2));

% Interactive Robot control
startTime = 0;
currentTime = 0;
endTime = trajectory.Duration;

robot = importrobot('soccer_description/models/soccerbot/model.xacro');
conf = homeConfiguration(robot);
ax = show(robot, conf);

b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',currentTime, 'min',startTime, 'max',endTime);
b.Callback = @(es,ed) updateConfiguration(ax, robot, conf, currentTime); 

legend('Expected Path', 'Simulation Ground Truth')

function updateConfiguration(es, ed, robot, conf, currentTime)
    es = show(robot, conf);
end
