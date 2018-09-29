%% Initialization Parameters
dh = [
    0.0280     -pi/2         0      pi/2
         0      pi/2         0     -pi/2
         0         0    0.0930         0
         0         0    0.0827         0
         0         0         0      pi/2
         0         0    0.0253         0
];
body_height = 0.099 + 0.16;
body.depth = 0.1305;
body.height = 0.152;
body.width = 0.145;

%% Generate Angles

start_pose = Pose(0, 0, 0, 0, 0.0);
mid1_pose = Pose(0.1, 0, 0, 0, 0.04);
top_pose = Pose(0.4, 0.2, 0, 0, 0.04);
bot_pose = Pose(0.4, -0.2, 0, -pi, 0.04);
mid2_pose = Pose(0.1, 0, 0, -pi, 0.04);
end_pose = Pose(0.1, 0, 0, 0, 0.0);

poseActions{1} = PoseAction(start_pose, Command.ActionLabel.PrepareLeft, 0.5);
poseActions{2} = PoseAction(mid1_pose, Command.ActionLabel.Forward, 2);
poseActions{3} = PoseAction(top_pose, Command.ActionLabel.Strafe, 5);
poseActions{4} = PoseAction(bot_pose, Command.ActionLabel.Forward, 7);
poseActions{5} = PoseAction(mid2_pose, Command.ActionLabel.Forward, 5);
poseActions{6} = PoseAction(end_pose, Command.ActionLabel.Turn, 3);
poseActions{7} = PoseAction(end_pose, Command.ActionLabel.FixStance, 1);
poseActions{8} = PoseAction(end_pose, Command.ActionLabel.Kick, 1);
poseActions{9} = PoseAction(end_pose, Command.ActionLabel.Rest, 0.5);

[angles, q0_left, q0_right] = run(poseActions);

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
in = in.setVariable('hip_width', 0.063, 'Workspace', 'biped_robot');
in = in.setVariable('body', body, 'Workspace', 'biped_robot');
in = in.setVariable('init_angle', start_pose.q, 'Workspace', 'biped_robot');

out = sim(in);