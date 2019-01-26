
load_system('soccer_vision');
in = Simulink.SimulationInput('soccer_vision');
in = in.setModelParameter('SimulationMode', 'Normal');

simOut = sim(in);
