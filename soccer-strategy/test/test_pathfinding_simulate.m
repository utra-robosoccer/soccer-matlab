test_pathfinding

% Get the actual trajectory
[simTime, simPose] = robot.SimulateTrajectory(path);
close all;

hold on;
grid minor;
map.Draw();
path.DrawPath();
plot(simPose(:,1), simPose(:,2));
