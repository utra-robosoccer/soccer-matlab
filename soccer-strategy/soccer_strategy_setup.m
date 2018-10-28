% Load Paths
addpath('soccer-strategy/fixed_trajectories')
addpath('soccer-strategy/systems')
addpath('soccer-strategy/data')

% Connect Robot
connectRobot;

% Sample Time
sampleTime = 0.01;

% Calibration
motorCalibration = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];

% Fixed Trajectories
loadFixedTrajectories