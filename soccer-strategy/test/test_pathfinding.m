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
<<<<<<< HEAD
trajectory = map.FindTrajectory(robot, endPose, robot.speed);

=======
trajectory = map.FindTrajectory(robot.pose, endPose, robot.speed);
for i = 1:length(trajectory.waypoints)
    disp(trajectory.poseactions{i}.ActionLabel);
end
>>>>>>> dc0a76b95fd662a753b984d628a5704ee9b35f52
% Draw the angles
% figure;
% trajectory.PlotAngles();

% Get the actual trajectory
trajectory.AverageSpeed();
[simTime, simPose] = robot.SimulationTrajectory(trajectory);
close all;

<<<<<<< HEAD
=======
legend('Expected Path', 'Simulation Ground Truth')

>>>>>>> dc0a76b95fd662a753b984d628a5704ee9b35f52
hold on;
grid minor;
map.Draw();
trajectory.DrawPath();
<<<<<<< HEAD
plot(simPose(:,1), simPose(:,2));
=======
plot(simPose(:,1), simPose(:,2));
>>>>>>> dc0a76b95fd662a753b984d628a5704ee9b35f52
