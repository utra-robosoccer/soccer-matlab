Ts = 0.01; % Sample Time

% Poses
if ~exist('manual', 'var')
    load('poses.mat')
end

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
