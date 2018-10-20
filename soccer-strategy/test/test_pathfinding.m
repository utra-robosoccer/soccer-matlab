destPose = Pose(2.5,2.5,10,0,0);

self = Navigation.Object(Pose(0,0,10,0,0), Navigation.ObstacleType.Self);
obs1 = Navigation.Object(Pose(1.3,1.3,0,0,0), Navigation.ObstacleType.Friendly);
obs2 = Navigation.Object(Pose(-1.7,1.7,0,0,0), Navigation.ObstacleType.Friendly);
obs3 = Navigation.Object(Pose(1.5,-1.5,0,0,0), Navigation.ObstacleType.Friendly);

obstacles = {obs1, obs2, obs3};

speed = 0.05; % m/s

[trajectory, q0_left, q0_right] = findTrajectory(curPose, destPose, obstacles, speed);
trajectoryFitted = trajectory;
trajectoryFitted(20,1) = 0;
customTrajectory = timeseries(trajectoryFitted');

%% Simulate based on these angles
dh = [
    0.0280     -pi/2         0      pi/2
         0      pi/2         0     -pi/2
         0         0    0.0930         0
         0         0    0.0827         0
         0         0         0      pi/2
         0         0    0.0253         0
];
body_height = 0.17;%0.099 + 0.16;
body.depth = 0.1305;
body.height = 0.152;
body.width = 0.145;

load_system('biped_robot');
in = Simulink.SimulationInput('biped_robot');
in = in.setModelParameter('StartTime', '0', 'StopTime', num2str(300));
in = in.setModelParameter('SimulationMode', 'Normal');

angles_ts = timeseries(trajectory, (0:length(trajectory)-1)*0.01);

in = in.setVariable('dh', dh, 'Workspace', 'biped_robot');
in = in.setVariable('q0_left', q0_left, 'Workspace', 'biped_robot');
in = in.setVariable('q0_right', q0_right, 'Workspace', 'biped_robot');
in = in.setVariable('angles', angles_ts, 'Workspace', 'biped_robot');
in = in.setVariable('init_body_height', body_height, 'Workspace', 'biped_robot');
in = in.setVariable('hip_width', 0.063, 'Workspace', 'biped_robot');
in = in.setVariable('body', body, 'Workspace', 'biped_robot');
in = in.setVariable('init_angle', curPose.q, 'Workspace', 'biped_robot');

out = sim(in);