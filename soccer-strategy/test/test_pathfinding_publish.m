% Connects to the simulation (gazebo)
connectrobot

% Generate a trajectory
test_pathfinding
jointangles = trajectory.UrdfConventionAngles;

robotgoalpub = rospublisher('/robotGoal','soccer_msgs/RobotGoal');
msg = rosmessage(robotgoalpub);

for i = 1:length(jointangles)
    msg.Trajectories(1:12) = jointangles(1:12,i);
    robotgoalpub.send(msg)
    pause(0.01)
end
