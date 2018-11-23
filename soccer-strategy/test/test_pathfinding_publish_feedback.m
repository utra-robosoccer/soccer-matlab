% Connects to the simulation (gazebo)
connectrobot

% Generate a trajectory
test_pathfinding

duration = 30;
load_system('soccer_strategy');
in = Simulink.SimulationInput('soccer_strategy');
in = in.setModelParameter('StartTime', '0', 'StopTime', 30);
in = in.setModelParameter('SimulationMode', 'Accelerated');

simOut = sim(in);