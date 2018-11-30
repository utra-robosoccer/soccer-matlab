%% Initialization Parameters
dh = csvread('soccer_description/models/soccerbot/dh.table',2,0,[2,0,7,4]); 
% % DH table starts from 'base_link'
% dh_arm = [
%         0       pi/2        0.3536      0
%         0.0157  0           0.0725      0
%         0.1     0           0           -pi/2
% ];
% dh_arm = dh_arm(:, [3 4 1 2 ]);   
% 
% % DH table starts from 'torso'
% dh_leg = [
%      -0.0135     pi/2         0.035      0
%          0      -pi/2         0.156      0
%          0         0          0          0
%          0.0929    0          0        -pi/2
%          0         0          0          0
%          0.0827  -pi/2        0          0
% ];
% dh_led = dh(:, [3 4 1 2 ]); % inverting columns d,theta,a,alpha vs. a,alpha,d,theta


body_height = 0.099 + 0.16;
body.depth = 0.1305;
body.height = 0.152;
body.width = 0.145;
ground.length = 9;
ground.width = 6;
ground.depth = 0.01;
gravity = 9.81;

%% Generate Angles

start_pose = Pose(0, 0, 0, 0, 0.0);
mid1_pose = Pose(0.1, 0, 0, 0, 0.04);
top_pose = Pose(0.4, 0.2, 0, 0, 0.04);
bot_pose = Pose(0.4, -0.2, 0, -pi, 0.04);
mid2_pose = Pose(0.1, 0, 0, -pi, 0.04);
end_pose = Pose(0.1, 0, 0, 0, 0.0);

poseActions{1} = Navigation.PoseAction(start_pose, Command.ActionLabel.PrepareLeft, 0.5);
poseActions{2} = Navigation.PoseAction(mid1_pose, Command.ActionLabel.Forward, 2);
poseActions{3} = Navigation.PoseAction(top_pose, Command.ActionLabel.Strafe, 5);
poseActions{4} = Navigation.PoseAction(bot_pose, Command.ActionLabel.Forward, 7);
poseActions{5} = Navigation.PoseAction(mid2_pose, Command.ActionLabel.Forward, 5);
poseActions{6} = Navigation.PoseAction(end_pose, Command.ActionLabel.Turn, 3);
poseActions{7} = Navigation.PoseAction(end_pose, Command.ActionLabel.FixStance, 1);
poseActions{8} = Navigation.PoseAction(end_pose, Command.ActionLabel.Kick, 1);
poseActions{9} = Navigation.PoseAction(end_pose, Command.ActionLabel.Rest, 0.5);

[angles, q0_left, q0_right] = createtrajectory(poseActions);

%% Simulate based on these angles
load_system('biped_robot');
in = Simulink.SimulationInput('biped_robot');
in = in.setModelParameter('StartTime', '0', 'StopTime', num2str(30));
in = in.setModelParameter('SimulationMode', 'Normal');

angles_ts = timeseries(angles, (0:length(angles)-1)*0.01);

in = in.setVariable('dh', dh, 'Workspace', 'biped_robot');
in = in.setVariable('q0_left', q0_left, 'Workspace', 'biped_robot');
in = in.setVariable('q0_right', q0_right, 'Workspace', 'biped_robot');
in = in.setVariable('angles', angles_ts, 'Workspace', 'biped_robot');
in = in.setVariable('init_body_height', body_height, 'Workspace', 'biped_robot');
in = in.setVariable('hip_width', 0.07, 'Workspace', 'biped_robot');
in = in.setVariable('body', body, 'Workspace', 'biped_robot');
in = in.setVariable('init_angle', start_pose.q, 'Workspace', 'biped_robot');
in = in.setVariable('body_mass', 1.529201,'Workspace', 'biped_robot');
in = in.setVariable('ground', ground,'Workspace', 'biped_robot');
in = in.setVariable('gravity', gravity,'Workspace', 'biped_robot');


out = sim(in);