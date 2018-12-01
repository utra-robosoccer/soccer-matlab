% Calibration
motorCalibration = [ ...
    0; ... % Torso              -    Right Hip (Side)
    0; ... % Right Hip (Side)   -    Right Hip (Front)
    0.05;...0.09; ... % Right Hip (Front)  -    Right Thigh
    0.05; ... % Right Thigh        -    Right Calve
    0; ... % Right Calve        -    Right Ankle
    0; ... % Right Ankle        -    Right Foot
    0; ... % Torso              -    Left Hip (Side)
    0; ... % Left Hip (Side)    -    Left Hip (Front)
    0; ... % Left Hip (Front)   -    Left Thigh
    0; ... % Left Thigh         -    Left Calve
    0; ... % Left Calve         -    Left Ankle
    0; ... % Left Ankle         -    Left Foot
    0; ... % Torso              -    Right Bicep
    0; ... % Right Bicep        -    Right Forearm
    0; ... % Torso              -    Left Bicep
    0; ... % Left Bicep         -    Left Forearm
    0; ... % Torso              -    Neck
    0; ... % Neck               -    Head
    0; ... %
    0]; %