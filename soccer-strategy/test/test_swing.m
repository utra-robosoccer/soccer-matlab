close all; clear; clc;

% Create a robot
pose = Pose(0,0,0,0,0);
robot = Navigation.Robot(pose, Navigation.EntityType.Self, 0.05);

%% Create the oscillating movement for the left foot
stancecount = 5;
foot = Mechanics.Foot.Right;
[angles, states, q0_left, q0_right] = robot.CreateAnimationOscillatingSwing(foot, stancecount);

path = Navigation.Path(pose, pose, angles);
path.q0_left = q0_left;
path.q0_right = q0_right;
path.states = states;

% Draw the angles
path.PlotAngles;

