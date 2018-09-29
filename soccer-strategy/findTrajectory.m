function [trajectory, q0_left, q0_right] = findTrajectory(curPose, destPose, obstacles, speed)

waypoints = findWayPoints(curPose, destPose, obstacles);
grid on;

figure
poseActionList = wayPointsToPoseActionList(waypoints, speed);
[trajectory, q0_left, q0_right] = run(poseActionList);

end