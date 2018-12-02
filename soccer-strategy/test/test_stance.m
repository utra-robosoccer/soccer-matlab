close all; clear; clc;

% Create a robot
pose = Pose(0,0,0,0,0);
robot = Navigation.Robot(pose, Navigation.EntityType.Self, 0.0001);

% Create the oscillating movement
stancecount = 8;
[angles, states, q0_left, q0_right] = robot.CreateAnimationOscillatingStance(stancecount);

path = Navigation.Path(pose, pose, angles);
path.q0_left = q0_left;
path.q0_right = q0_right;
path.states = states;

path.ApplyTilt(0.0015, robot.stance_time / 2);

% Draw the angles
path.PlotAngles;
