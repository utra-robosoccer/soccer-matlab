close all; clear; clc;
figure;
obstaclecount = 8;

% Repeats 10 times to see if there is an error from probability
for i = 1:10
    
    disp(strcat('Setting up environment for test', num2str(i)));
    
    % Create a map
    map = Navigation.Map(9, 6, 0.05);
    
    % Create a robot
    robot = Navigation.Robot(Pose(0,0,pi/2,0,0), Navigation.EntityType.Self, 0.05);

    % Add obstacles
    for j = 1:obstaclecount
        obs = Navigation.Entity(map.RandomPose, Navigation.EntityType.Friendly);
        map.AddObject(obs);
    end
    
    % Destination position
    endPose = map.RandomPose;

    % Attempt
    path = map.FindPath(robot.pose, endPose, robot.speed);
    
    disp(strcat('Trajectory found for test ', num2str(i), ' avg speed: ', num2str(trajectory.AverageSpeed)));
    hold off;
    map.Draw();
    hold on;
    path.DrawPath();
    grid minor;
    drawnow;
end

disp('Success')