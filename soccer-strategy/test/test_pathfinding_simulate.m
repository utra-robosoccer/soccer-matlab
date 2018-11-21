test_pathfinding

% Get the actual trajectory
trajectory.AverageSpeed();
[simTime, simPose] = robot.SimulationTrajectory(trajectory);
close all;

hold on;
grid minor;
map.Draw();
trajectory.DrawPath();
plot(simPose(:,1), simPose(:,2));
