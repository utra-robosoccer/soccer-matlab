%% To run this file you have to be in the soccer-matlab folder

% Poses
poses = load('poses.mat');
csvwrite('soccer-rl/trajectories/standing.csv', poses.standing);
csvwrite('soccer-rl/trajectories/ready.csv', poses.ready);

% Trajectories
animations = load('animations.mat');
csvwrite('soccer-rl/trajectories/getupback.csv', animations.getUpBackWayPoints);
csvwrite('soccer-rl/trajectories/getupfront.csv', animations.getUpFrontWayPoints);

% Dynamic Trajectories
cd soccer-control
demo
cd ..
angles(20,:) = 0; % make the size good
csvwrite('soccer-rl/trajectories/test-animation.csv', angles);