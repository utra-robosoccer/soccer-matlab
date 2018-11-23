% Connects to the simulation (gazebo)
load_system('soccer_strategy');
in = Simulink.SimulationInput('soccer_strategy');

simOut = sim(in);