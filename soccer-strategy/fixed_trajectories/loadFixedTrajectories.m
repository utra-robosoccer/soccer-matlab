Ts = 0.01; % Sample Time

% Poses
if ~exist('manual', 'var')
    load('poses.mat')
end

% Manually change position of one motor
% clear customTrajectory
% manual =  zeros(1,20);
% motor_idx = 18;
% manual(motor_idx) = pi/6;

% Animations
load('animations.mat')

[getupfrontspline, getupfrontsmooth] = createFixedTrajectory(getUpFrontWayPoints, Ts, 20, 0.02);
[getupbackspline, getupbacksmooth] = createFixedTrajectory(getUpBackWayPoints, Ts, 5, 0.1);

% Pose Transitions
standingtoready = changePoseTrajectory(standing, ready, Ts, 10);
readytostanding = changePoseTrajectory(ready, standing, Ts, 10);

% Customized Transitions
headNoddingTrajectory = createHeadNoddingTrajectory(ready);
headShakingTrajectory = createHeadShakingTrajectory(ready);

if ~exist('customTrajectory', 'var')
    customTrajectory = timeseries([manual;manual], [0;0]);
end
