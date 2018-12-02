% Generate a trajectory
test_walking;
soccer_strategy_calibration;

close all;
% Simply publish, add 1 as first argument for stepping
path.animation.calibration = motorCalibration';
path.Publish;