% Generate a trajectory
test_stance;

% Simply publish, add 1 as first argument for stepping
soccer_strategy_calibration;
path.animation.calibration = motorCalibration';
path.Publish;