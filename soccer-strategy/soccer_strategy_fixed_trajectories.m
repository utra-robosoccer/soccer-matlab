ts = 0.01; % Sample Time

% Load
if ~exist('manual', 'var')
    load('poses.mat')
end
if ~exist('customTrajectory', 'var')
    customTrajectory = timeseries([manual;manual], [0;0]);
end

% Poses
standingstate = Animation.State(standing);
readystate = Animation.State(ready);

standingtoreadyanimation = Animation.Animation.CreateAnimation(standingstate, readystate, ts, 10);
readytostandinganimation = Animation.Animation.CreateAnimation(readystate, standingstate, ts, 10);

% Animations
load('keyframes.mat')

getupfrontanimation = Animation.Animation.CreateAnimationKeyframes(getUpFrontWayPoints, ts, 20, 0.02);
getupbackanimation = Animation.Animation.CreateAnimationKeyframes(getUpBackWayPoints, ts, 20, 0.02);

headnoddinganimation = Animation.Animation.CreateAnimationHeadNodding(readystate, ts, 20);
headshakinganimation = Animation.Animation.CreateAnimationHeadShaking(readystate, ts, 20);

% Turn all the animations to time series
standingtoready = standingtoreadyanimation.GetTimeSeries;
readytostanding = readytostandinganimation.GetTimeSeries;
getupfrontsmooth = getupfrontanimation.GetTimeSeries;
getupbacksmooth = getupbackanimation.GetTimeSeries;
headnodding = headnoddinganimation.GetTimeSeries;
headshaking = headshakinganimation.GetTimeSeries;

% Clear unnessesary information
clear getUpBackWayPoints getUpFrontWayPoints getupbackanimation ...
    getupfrontanimation headnoddinganimation headshakinganimation readystate ...
    readytostandinganimation standingstate standingtoreadyanimation ts
