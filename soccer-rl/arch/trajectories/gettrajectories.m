%% To run this file you have to be in the soccer-matlab folder

% Load all the fixed trajectories
addpath('soccer-strategy/fixed_trajectories');
loadFixedTrajectories

% Poses
csvwrite('soccer-rl/trajectories/standing.csv', standing);
csvwrite('soccer-rl/trajectories/ready.csv', ready);

% Trajectories
csvwrite('soccer-rl/trajectories/getupback.csv', getupbacksmooth.Data);
csvwrite('soccer-rl/trajectories/getupfront.csv', getupfrontsmooth.Data);

% Dynamic Trajectories
cd soccer-control
demo
cd ..
angles(20,:) = 0; % make the size good
csvwrite('soccer-rl/trajectories/test-animation.csv', angles);