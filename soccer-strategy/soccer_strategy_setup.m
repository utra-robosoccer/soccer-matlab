% Load Paths
addpath('soccer-strategy/fixed_trajectories')
addpath('soccer-strategy/systems')
addpath('soccer-strategy/data')
addpath('soccer-strategy/tests')
savepath

% To prevent starting error
load('soccer-strategy/data/types.mat')

% Connect Robot
connectrobot;

% Sample Time
sampleTime = 0.01;

% Calibration
motorCalibration = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];

% Fixed Trajectories
loadFixedTrajectories

% Left Right Control
hipCalveGain = 1;
kneeGain = 2;

% Forward Backward control
forearmGain = 1.5;
feetGain = 0.1;



