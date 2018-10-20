function [trajectory, q0_left, q0_right] = findtrajectory(curPose, destPose, obstacles, speed)

waypoints = findwaypoints(curPose, destPose, obstacles);
grid on;

figure
poseActionList = findposeaction(waypoints, speed);
[trajectory, q0_left, q0_right] = run(poseActionList);

end