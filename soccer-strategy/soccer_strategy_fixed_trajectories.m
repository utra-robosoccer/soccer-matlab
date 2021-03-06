ts = 0.01; % Sample Time

% Load
if ~exist('manual', 'var')
    load('poses.mat')
end
if ~exist('customTrajectory', 'var') || ~exist('customTrajectoryStates', 'var') 
    customTrajectory = timeseries([manual;manual], [0;0]);
    customTrajectoryStates = timeseries([1;1],[0;0]);
end

% Poses
standingstate = Animation.State(standing);
readystate = Animation.State(ready);
squatstate = Animation.State(squat);

standingtoreadyanimation = Animation.Animation.CreateAnimation2States(standingstate, readystate, ts, 2);
readytostandinganimation = Animation.Animation.CreateAnimation2States(readystate, standingstate, ts, 2);

% Animations
load('keyframes.mat')

getupfrontanimation = Animation.Animation.CreateAnimationKeyframes(getUpFrontWayPoints, ts, 20, 0.02);
getupbackanimation = Animation.Animation.CreateAnimationKeyframes(getUpBackWayPoints, ts, 5, 0.02);

headnoddinganimation = Animation.Animation.CreateAnimationHeadNodding(readystate, ts, 5, pi/4);
headshakinganimation = Animation.Animation.CreateAnimationHeadShaking(readystate, ts, 5, pi/2);

% Turn all the animations to time series
standingtoready = standingtoreadyanimation.TimeSeries;
readytostanding = readytostandinganimation.TimeSeries;
getupfrontsmooth = getupfrontanimation.TimeSeries;
getupbacksmooth = getupbackanimation.TimeSeries;
headnodding = headnoddinganimation.TimeSeries;
headshaking = headshakinganimation.TimeSeries;


%% Static walking trajectory
pose = Pose(0,0,0,0,0);
robot = Navigation.Robot(pose, Navigation.EntityType.Self, 0.05);

% Create the oscillating movement
duration = 20;
speed = 0.4;
foot = Mechanics.Foot.Right;
[angles, states, q0_left, q0_right] = robot.CreateAnimationWalking(duration, speed);

path = Navigation.Path(pose, pose, angles);
path.q0_left = q0_left;
path.q0_right = q0_right;
path.states = states;

% Apply tilts
path.ApplyAnkleTilt(0.1);
path.ApplyTiltForward(0.05);
path.ApplyLegSpread(0.05);

walkingWayPoints = path.animation.trajectory;
walkingWayPoints(:,19:20) = 0;

% Arm position
walkingWayPoints(:,13:16) = repmat(ready_armsback(13:16), size(walkingWayPoints,1 ),1); 

walkinganimation = Animation.Animation.CreateAnimationKeyframes(walkingWayPoints, ts, duration, 0.00000001); % no smooth atm
walking = walkinganimation.TimeSeries;
walkingStates = states;

%% Stance trajectory
clear path
% Create the oscillating movement
stancecount = 5;
[angles, states, q0_left, q0_right] = robot.CreateAnimationOscillatingStance(stancecount);

path = Navigation.Path(pose, pose, angles);
path.q0_left = q0_left;
path.q0_right = q0_right;
path.states = states;

path.ApplyTiltForward(0.05);
path.ApplyLegSpread(0.1);

% Apply tilt
stanceWayPoints = path.animation.trajectory;
stanceWayPoints(:,19:20) = 0;

% Move arms backwards
stanceWayPoints(:,13:16) = repmat(ready_armsback(13:16), size(stanceWayPoints,1 ),1); 

stanceanimation = Animation.Animation.CreateAnimationKeyframes(stanceWayPoints, ts, duration, 0.00000001);
stance = stanceanimation.TimeSeries;
stanceStates = states;

% Clear unnessesary information
clear getUpBackWayPoints getUpFrontWayPoints ts
