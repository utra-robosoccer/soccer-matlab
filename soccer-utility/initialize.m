% Initial setup (Use only once)

% Soccer Description folders
addpath('soccer_description')

% Soccer Utility Folders
addpath('soccer-utility')
addpath('soccer-utility/general')

% Soccer Control Folders
addpath('soccer-control')
addpath('soccer-control/test')

% Soccer Vision Folders
addpath('soccer-vision')
addpath('soccer-vision/test')

% Soccer Strategy Folders
addpath('soccer-strategy')
addpath('soccer-strategy/test')

% Soccer RL Folders
addpath('soccer-rl')

savepath

% Generate Custom Messages
rosgenmsg('soccer-utility/soccer_msgs') 