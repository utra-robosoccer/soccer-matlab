% Load Paths
addpath('soccer-strategy/systems')
addpath('soccer-strategy/data')
addpath('soccer-strategy/test')
savepath

% To prevent starting error
load('soccer-strategy/data/bustypes.mat')

% Connect Robot
connectrobot;

% Select Angle Estimation block
VSS_DIRECT_INFORMATION = Simulink.Variant('useRobot==0');

% Sample Time
sampleTime = 0.01;

% Load motor calibration offsets
soccer_strategy_calibration;

% Fixed Trajectories
soccer_strategy_fixed_trajectories

% Left Right Control
hipCalveGain = 0;
kneeGain = 0;

% Forward Backward control
hipGain = 2;
forearmGain = 1.5;
feetGain = 0;

% Dynamic trajectory gains (stanceLeft = stance Left to Right)
% Pitch
stanceRight.pitch.rightHipSideFront.p = 0.0;
stanceRight.pitch.rightHipSideFront.i = 0.0;
stanceRight.pitch.rightHipSideFront.d = 0.0;
stanceRight.pitch.rightHipSideFront.direction = 1;
stanceRight.pitch.rightHipFrontThigh.p = 0.0;
stanceRight.pitch.rightHipFrontThigh.i = 0.0;
stanceRight.pitch.rightHipFrontThigh.d = 0.0;
stanceRight.pitch.rightHipFrontThigh.direction = 1;
stanceRight.pitch.rightCalveAnkle.p = 0.0;
stanceRight.pitch.rightCalveAnkle.i = 0.0;
stanceRight.pitch.rightCalveAnkle.d = 0.0;
stanceRight.pitch.rightCalveAnkle.direction = 1;
stanceRight.pitch.rightAnkleFoot.p = 0.0;
stanceRight.pitch.rightAnkleFoot.i = 0.0;
stanceRight.pitch.rightAnkleFoot.d = 0.0;
stanceRight.pitch.rightAnkleFoot.direction = 1;
stanceRight.pitch.desiredAngle = 0.0;

swingRight.pitch.rightHipSideFront.p = 0.0;
swingRight.pitch.rightHipSideFront.i = 0.0;
swingRight.pitch.rightHipSideFront.d = 0.0;
swingRight.pitch.rightHipSideFront.direction = 1;
swingRight.pitch.rightHipFrontThigh.p = 0;
swingRight.pitch.rightHipFrontThigh.i = 0.0;
swingRight.pitch.rightHipFrontThigh.d = 0.0;
swingRight.pitch.rightHipFrontThigh.direction = 1;
swingRight.pitch.rightCalveAnkle.p = 0.0;
swingRight.pitch.rightCalveAnkle.i = 0.0;
swingRight.pitch.rightCalveAnkle.d = 0.0;
swingRight.pitch.rightCalveAnkle.direction = 1;
swingRight.pitch.rightAnkleFoot.p = 0.0;
swingRight.pitch.rightAnkleFoot.i = 0.0;
swingRight.pitch.rightAnkleFoot.d = 0.0;
swingRight.pitch.rightAnkleFoot.direction = 1;
swingRight.pitch.desiredAngle = 0.0;

% Roll
stanceRight.roll.rightHipSideFront.p = 0;
stanceRight.roll.rightHipSideFront.i = 0.0;
stanceRight.roll.rightHipSideFront.d = 0.0;
stanceRight.roll.rightHipSideFront.direction = 1;
stanceRight.roll.rightHipFrontThigh.p = 0;
stanceRight.roll.rightHipFrontThigh.i = 0.0;
stanceRight.roll.rightHipFrontThigh.d = 0.0;
stanceRight.roll.rightHipFrontThigh.direction = 1;
stanceRight.roll.rightCalveAnkle.p = 0.0;
stanceRight.roll.rightCalveAnkle.i = 0.0;
stanceRight.roll.rightCalveAnkle.d = 0.0;
stanceRight.roll.rightCalveAnkle.direction = 1;
stanceRight.roll.rightAnkleFoot.p = 0.0;
stanceRight.roll.rightAnkleFoot.i = 0.0;
stanceRight.roll.rightAnkleFoot.d = 0.0;
stanceRight.roll.rightAnkleFoot.direction = 1;
stanceRight.roll.desiredAngle = 0.0;

swingRight.roll.rightHipSideFront.p = 0;
swingRight.roll.rightHipSideFront.i = 0.0;
swingRight.roll.rightHipSideFront.d = 0.0;
swingRight.roll.rightHipSideFront.direction = 1;
swingRight.roll.rightHipFrontThigh.p = 0.0;
swingRight.roll.rightHipFrontThigh.i = 0.0;
swingRight.roll.rightHipFrontThigh.d = 0.0;
swingRight.roll.rightHipFrontThigh.direction = 1;
swingRight.roll.rightCalveAnkle.p = 0.0;
swingRight.roll.rightCalveAnkle.i = 0.0;
swingRight.roll.rightCalveAnkle.d = 0.0;
swingRight.roll.rightCalveAnkle.direction = 1;
swingRight.roll.rightAnkleFoot.p = 0.0;
swingRight.roll.rightAnkleFoot.i = 0.0;
swingRight.roll.rightAnkleFoot.d = 0.0;
swingRight.roll.rightAnkleFoot.direction = 1;
swingRight.roll.desiredAngle = 0.0;

% override PID values for all motors
pid.p = 0.5;
pid.i = 0.5;
pid.d = 0.001;
pid.direction = 1;

% Replacate same variables for LEFT sates and LEFT leg
for rightstate = {'stanceRight', 'swingRight'}
    
    for euangle = fieldnames(eval(rightstate{1}))'
        for rightlink = fieldnames(eval([rightstate{1} '.' euangle{1}]))'
            leftstate = replace(rightstate, 'Right','Left');
            leftlink = replace(rightlink, 'right', 'left');
% %             Set all parameters the same
%             if ~strcmp(leftlink, 'desiredAngle')
%                 eval([rightstate{1} '.' euangle{1} '.' rightlink{1} '= pid']);
%             end
            eval([rightstate{1} '.' euangle{1} '.(''' leftlink{1} ''')=' rightstate{1} '.' euangle{1} '.' rightlink{1} ';']);
            eval([leftstate{1} '.' euangle{1} '.(''' leftlink{1} ''')=' rightstate{1} '.' euangle{1} '.' rightlink{1} ';']);
            eval([leftstate{1} '.' euangle{1} '.(''' rightlink{1} ''')=' rightstate{1} '.' euangle{1} '.' rightlink{1} ';']);
        end
    end
end

% Override gains (Uncomment gain you want to override)

% stanceLeft.pitch.rightHipSideFront.p = 0.4;
% stanceLeft.pitch.rightHipSideFront.i = 0.0;
% stanceLeft.pitch.rightHipSideFront.d = 0.0;
% stanceLeft.pitch.rightHipSideFront.direction = 1;
% stanceLeft.pitch.rightHipFrontThigh.p = 0.0;
% stanceLeft.pitch.rightHipFrontThigh.i = 0.0;
% stanceLeft.pitch.rightHipFrontThigh.d = 0.0;
% stanceLeft.pitch.rightHipFrontThigh.direction = 1;
% stanceLeft.pitch.rightCalveAnkle.p = 0.0;
% stanceLeft.pitch.rightCalveAnkle.i = 0.0;
% stanceLeft.pitch.rightCalveAnkle.d = 0.0;
% stanceLeft.pitch.rightCalveAnkle.direction = 1;
% stanceLeft.pitch.rightAnkleFoot.p = 0.0;
% stanceLeft.pitch.rightAnkleFoot.i = 0.0;
% stanceLeft.pitch.rightAnkleFoot.d = 0.0;
% stanceLeft.pitch.rightAnkleFoot.direction = 1;

% stanceLeft.pitch.leftHipSideFront.p = 0.4;
% stanceLeft.pitch.leftHipSideFront.i = 0.0;
% stanceLeft.pitch.leftHipSideFront.d = 0.0;
% stanceLeft.pitch.leftHipSideFront.direction = 1;
% stanceLeft.pitch.leftHipFrontThigh.p = 0.0;
% stanceLeft.pitch.leftHipFrontThigh.i = 0.0;
% stanceLeft.pitch.leftHipFrontThigh.d = 0.0;
% stanceLeft.pitch.leftHipFrontThigh.direction = 1;
% stanceLeft.pitch.leftCalveAnkle.p = 0.0;
% stanceLeft.pitch.leftCalveAnkle.i = 0.0;
% stanceLeft.pitch.leftCalveAnkle.d = 0.0;
% stanceLeft.pitch.leftCalveAnkle.direction = 1;
% stanceLeft.pitch.leftAnkleFoot.p = 0.0;
% stanceLeft.pitch.leftAnkleFoot.i = 0.0;
% stanceLeft.pitch.leftAnkleFoot.d = 0.0;
% stanceLeft.pitch.leftAnkleFoot.direction = 1;
% stanceLeft.pitch.desiredAngle = 0.0;


% stanceLeft.roll.rightHipSideFront.p = 0.0;
% stanceLeft.roll.rightHipSideFront.i = 0.0;
% stanceLeft.roll.rightHipSideFront.d = 0.0;
% stanceLeft.roll.rightHipSideFront.direction = 1;
% stanceLeft.roll.rightHipFrontThigh.p = 0.0;
% stanceLeft.roll.rightHipFrontThigh.i = 0.0;
% stanceLeft.roll.rightHipFrontThigh.d = 0.0;
% stanceLeft.roll.rightHipFrontThigh.direction = 1;
% stanceLeft.roll.rightCalveAnkle.p = 0.0;
% stanceLeft.roll.rightCalveAnkle.i = 0.0;
% stanceLeft.roll.rightCalveAnkle.d = 0.0;
% stanceLeft.roll.rightCalveAnkle.direction = 1;
% stanceLeft.roll.rightAnkleFoot.p = 0.0;
% stanceLeft.roll.rightAnkleFoot.i = 0.0;
% stanceLeft.roll.rightAnkleFoot.d = 0.0;
% stanceLeft.roll.rightAnkleFoot.direction = 1;

% stanceLeft.roll.leftHipSideFront.p = 0.0;
% stanceLeft.roll.leftHipSideFront.i = 0.0;
% stanceLeft.roll.leftHipSideFront.d = 0.0;
% stanceLeft.roll.leftHipSideFront.direction = 1;
% stanceLeft.roll.leftHipFrontThigh.p = 0.0;
% stanceLeft.roll.leftHipFrontThigh.i = 0.0;
% stanceLeft.roll.leftHipFrontThigh.d = 0.0;
% stanceLeft.roll.leftHipFrontThigh.direction = 1;
% stanceLeft.roll.leftCalveAnkle.p = 0.0;
% stanceLeft.roll.leftCalveAnkle.i = 0.0;
% stanceLeft.roll.leftCalveAnkle.d = 0.0;
% stanceLeft.roll.leftCalveAnkle.direction = 1;
% stanceLeft.roll.leftAnkleFoot.p = 0.0;
% stanceLeft.roll.leftAnkleFoot.i = 0.0;
% stanceLeft.roll.leftAnkleFoot.d = 0.0;
% stanceLeft.roll.leftAnkleFoot.direction = 1;
% stanceLeft.roll.desiredAngle = 0.0;


% stanceRight.pitch.leftHipSideFront.p = 0.0;
% stanceRight.pitch.leftHipSideFront.i = 0.0;
% stanceRight.pitch.leftHipSideFront.d = 0.0;
% stanceRight.pitch.leftHipSideFront.direction = 1;
% stanceRight.pitch.leftHipFrontThigh.p = 0.0;
% stanceRight.pitch.leftHipFrontThigh.i = 0.0;
% stanceRight.pitch.leftHipFrontThigh.d = 0.0;
% stanceRight.pitch.leftHipFrontThigh.direction = 1;
% stanceRight.pitch.leftCalveAnkle.p = 0.0;
% stanceRight.pitch.leftCalveAnkle.i = 0.0;
% stanceRight.pitch.leftCalveAnkle.d = 0.0;
% stanceRight.pitch.leftCalveAnkle.direction = 1;
% stanceRight.pitch.leftAnkleFoot.p = 0.0;
% stanceRight.pitch.leftAnkleFoot.i = 0.0;
% stanceRight.pitch.leftAnkleFoot.d = 0.0;
% stanceRight.pitch.leftAnkleFoot.direction = 1;

% stanceRight.roll.leftHipSideFront.p = 0.0;
% stanceRight.roll.leftHipSideFront.i = 0.0;
% stanceRight.roll.leftHipSideFront.d = 0.0;
% stanceRight.roll.leftHipSideFront.direction = 1;
% stanceRight.roll.leftHipFrontThigh.p = 0.0;
% stanceRight.roll.leftHipFrontThigh.i = 0.0;
% stanceRight.roll.leftHipFrontThigh.d = 0.0;
% stanceRight.roll.leftHipFrontThigh.direction = 1;
% stanceRight.roll.leftCalveAnkle.p = 0.0;
% stanceRight.roll.leftCalveAnkle.i = 0.0;
% stanceRight.roll.leftCalveAnkle.d = 0.0;
% stanceRight.roll.leftCalveAnkle.direction = 1;
% stanceRight.roll.leftAnkleFoot.p = 0.0;
% stanceRight.roll.leftAnkleFoot.i = 0.0;
% stanceRight.roll.leftAnkleFoot.d = 0.0;
% stanceRight.roll.leftAnkleFoot.direction = 1;


% swingLeft.pitch.rightHipSideFront.p = 0.0;
% swingLeft.pitch.rightHipSideFront.i = 0.0;
% swingLeft.pitch.rightHipSideFront.d = 0.0;
% swingLeft.pitch.rightHipSideFront.direction = 1;
% swingLeft.pitch.rightHipFrontThigh.p = 0.0;
% swingLeft.pitch.rightHipFrontThigh.i = 0.0;
% swingLeft.pitch.rightHipFrontThigh.d = 0.0;
% swingLeft.pitch.rightHipFrontThigh.direction = 1;
% swingLeft.pitch.rightCalveAnkle.p = 0.0;
% swingLeft.pitch.rightCalveAnkle.i = 0.0;
% swingLeft.pitch.rightCalveAnkle.d = 0.0;
% swingLeft.pitch.rightCalveAnkle.direction = 1;
% swingLeft.pitch.rightAnkleFoot.p = 0.0;
% swingLeft.pitch.rightAnkleFoot.i = 0.0;
% swingLeft.pitch.rightAnkleFoot.d = 0.0;
% swingLeft.pitch.rightAnkleFoot.direction = 1;

% swingLeft.pitch.leftHipSideFront.p = 0.0;
% swingLeft.pitch.leftHipSideFront.i = 0.0;
% swingLeft.pitch.leftHipSideFront.d = 0.0;
% swingLeft.pitch.leftHipSideFront.direction = 1;
% swingLeft.pitch.leftHipFrontThigh.p = 0.0;
% swingLeft.pitch.leftHipFrontThigh.i = 0.0;
% swingLeft.pitch.leftHipFrontThigh.d = 0.0;
% swingLeft.pitch.leftHipFrontThigh.direction = 1;
% swingLeft.pitch.leftCalveAnkle.p = 0.0;
% swingLeft.pitch.leftCalveAnkle.i = 0.0;
% swingLeft.pitch.leftCalveAnkle.d = 0.0;
% swingLeft.pitch.leftCalveAnkle.direction = 1;
% swingLeft.pitch.leftAnkleFoot.p = 0.0;
% swingLeft.pitch.leftAnkleFoot.i = 0.0;
% swingLeft.pitch.leftAnkleFoot.d = 0.0;
% swingLeft.pitch.leftAnkleFoot.direction = 1;
% swingLeft.pitch.desiredAngle = 0.0;

% swingLeft.roll.rightHipSideFront.p = 0.0;
% swingLeft.roll.rightHipSideFront.i = 0.0;
% swingLeft.roll.rightHipSideFront.d = 0.0;
% swingLeft.roll.rightHipSideFront.direction = 1;
% swingLeft.roll.rightHipFrontThigh.p = 0.0;
% swingLeft.roll.rightHipFrontThigh.i = 0.0;
% swingLeft.roll.rightHipFrontThigh.d = 0.0;
% swingLeft.roll.rightHipFrontThigh.direction = 1;
% swingLeft.roll.rightCalveAnkle.p = 0.0;
% swingLeft.roll.rightCalveAnkle.i = 0.0;
% swingLeft.roll.rightCalveAnkle.d = 0.0;
% swingLeft.roll.rightCalveAnkle.direction = 1;
% swingLeft.roll.rightAnkleFoot.p = 0.0;
% swingLeft.roll.rightAnkleFoot.i = 0.0;
% swingLeft.roll.rightAnkleFoot.d = 0.0;
% swingLeft.roll.rightAnkleFoot.direction = 1;

% swingLeft.roll.leftHipSideFront.p = 0.0;
% swingLeft.roll.leftHipSideFront.i = 0.0;
% swingLeft.roll.leftHipSideFront.d = 0.0;
% swingLeft.roll.leftHipSideFront.direction = 1;
% swingLeft.roll.leftHipFrontThigh.p = 0.0;
% swingLeft.roll.leftHipFrontThigh.i = 0.0;
% swingLeft.roll.leftHipFrontThigh.d = 0.0;
% swingLeft.roll.leftHipFrontThigh.direction = 1;
% swingLeft.roll.leftCalveAnkle.p = 0.0;
% swingLeft.roll.leftCalveAnkle.i = 0.0;
% swingLeft.roll.leftCalveAnkle.d = 0.0;
% swingLeft.roll.leftCalveAnkle.direction = 1;
% swingLeft.roll.leftAnkleFoot.p = 0.0;
% swingLeft.roll.leftAnkleFoot.i = 0.0;
% swingLeft.roll.leftAnkleFoot.d = 0.0;
% swingLeft.roll.leftAnkleFoot.direction = 1;
% swingLeft.roll.desiredAngle = 0.0;


% swingRight.pitch.leftHipSideFront.p = 0.0;
% swingRight.pitch.leftHipSideFront.i = 0.0;
% swingRight.pitch.leftHipSideFront.d = 0.0;
% swingRight.pitch.leftHipSideFront.direction = 1;
% swingRight.pitch.leftHipFrontThigh.p = 0.0;
% swingRight.pitch.leftHipFrontThigh.i = 0.0;
% swingRight.pitch.leftHipFrontThigh.d = 0.0;
% swingRight.pitch.leftHipFrontThigh.direction = 1;
% swingRight.pitch.leftCalveAnkle.p = 0.0;
% swingRight.pitch.leftCalveAnkle.i = 0.0;
% swingRight.pitch.leftCalveAnkle.d = 0.0;
% swingRight.pitch.leftCalveAnkle.direction = 1;
% swingRight.pitch.leftAnkleFoot.p = 0.0;
% swingRight.pitch.leftAnkleFoot.i = 0.0;
% swingRight.pitch.leftAnkleFoot.d = 0.0;
% swingRight.pitch.leftAnkleFoot.direction = 1;

% swingRight.roll.leftHipSideFront.p = 0.0;
% swingRight.roll.leftHipSideFront.i = 0.0;
% swingRight.roll.leftHipSideFront.d = 0.0;
% swingRight.roll.leftHipSideFront.direction = 1;
% swingRight.roll.leftHipFrontThigh.p = 0.0;
% swingRight.roll.leftHipFrontThigh.i = 0.0;
% swingRight.roll.leftHipFrontThigh.d = 0.0;
% swingRight.roll.leftHipFrontThigh.direction = 1;
% swingRight.roll.leftCalveAnkle.p = 0.0;
% swingRight.roll.leftCalveAnkle.i = 0.0;
% swingRight.roll.leftCalveAnkle.d = 0.0;
% swingRight.roll.leftCalveAnkle.direction = 1;
% swingRight.roll.leftAnkleFoot.p = 0.0;
% swingRight.roll.leftAnkleFoot.i = 0.0;
% swingRight.roll.leftAnkleFoot.d = 0.0;
% swingRight.roll.leftAnkleFoot.direction = 1;


motorFeedback = Feedback.MotorFeedback(stanceLeft,stanceRight,swingLeft,swingRight);
motorFeedback.rightHipSideFront.roll.enabled =1;
motorFeedback.rightHipFrontThigh.roll.enabled = 1;
motorFeedback.rightCalveAnkle.roll.enabled = 1;
motorFeedback.rightAnkleFoot.roll.enabled = 1;
motorFeedback.leftHipSideFront.roll.enabled = 1;
motorFeedback.leftHipFrontThigh.roll.enabled = 1;
motorFeedback.leftCalveAnkle.roll.enabled = 1;
motorFeedback.leftAnkleFoot.roll.enabled = 1;
motorFeedback.rightHipSideFront.pitch.enabled = 1;
motorFeedback.rightHipFrontThigh.pitch.enabled = 1;
motorFeedback.rightCalveAnkle.pitch.enabled = 1;
motorFeedback.rightAnkleFoot.pitch.enabled = 1;
motorFeedback.leftHipSideFront.pitch.enabled = 1;
motorFeedback.leftHipFrontThigh.pitch.enabled = 1;
motorFeedback.leftCalveAnkle.pitch.enabled = 1;
motorFeedback.leftAnkleFoot.pitch.enabled = 1;

