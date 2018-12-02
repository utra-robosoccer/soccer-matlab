close all; clear; clc;

% Create a robot
pose = Pose(0,0,0,0,0);
robot = Navigation.Robot(pose, Navigation.EntityType.Self, 0.05);

% Create the oscillating movement
duration = 20;
speed = 0.001;
foot = Mechanics.Foot.Right;
[angles, states, q0_left, q0_right] = robot.CreateAnimationWalking(duration, speed);

path = Navigation.Path(pose, pose, angles);
path.q0_left = q0_left;
path.q0_right = q0_right;
path.states = states;

path.ApplyTiltForward(0.5);
%path.ApplyTilt(0.001, robot.stance_time / 2);

% Draw the angles
path.PlotAngles;


