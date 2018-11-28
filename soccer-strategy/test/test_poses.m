close all; clear; clc;
soccer_strategy_setup;

%% Standing
standingstate.calibration = motorCalibration';
standingstate.Publish

%% Ready
readystate.calibration = motorCalibration';
readystate.Publish

%% Get Up Front Animation
getupfrontanimation.Plot
getupfrontanimation.Publish

%% Get Up Back Animation
getupbackanimation.Plot
getupbackanimation.Publish

%% Head Nodding Animation
headnoddinganimation.Plot
headnoddinganimation.Publish

%% Head Shaking Animation
headshakinganimation.Plot
headshakinganimation.Publish

%% Standing to Ready Animation
standingtoreadyanimation.Plot
standingtoreadyanimation.Publish

%% Ready to standing Animation
readytostandinganimation.Plot
readytostandinganimation.Publish