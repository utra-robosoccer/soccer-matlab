classdef Robot < Navigation.Entity

    properties
        dh % Dh table for the robot
        speed = 0.05 % m/s
        body_height = 0.17;
        body = struct('depth',0.17, 'height', 0.152, 'width', 0.145);
        
    end
    
    methods
        function obj = Robot(pose, type, speed)
            
            % Parent constructor
            obj@Navigation.Entity(pose, type); 
            
            % ROBOT Construct an instance of this class
            obj.speed = speed;
            
            % Load DH table
            path_folders = genpath('soccer_description');
            addpath(genpath(path_folders));
            obj.dh = csvread('soccer_description/models/soccerbot/dh.table',2,0,[2,0,7,4]); 
            rmpath(genpath(path_folders));
            
            obj.body_height = 0.17;%0.099 + 0.16;
            obj.body.depth = 0.1305;
            obj.body.height = 0.152;
            obj.body.width = 0.145;
        end
        
        function [simTime, simPosition] = SimulationTrajectory(obj, trajectory)
            % Trajectory = [1x1] Navigation.Trajectory
            
            load_system('biped_robot');
            in = Simulink.SimulationInput('biped_robot');
            in = in.setModelParameter('StartTime', '0', 'StopTime', num2str(trajectory.Duration));
            in = in.setModelParameter('SimulationMode', 'Normal');

            angles_ts = timeseries(trajectory.angles, (0:length(trajectory.angles)-1)*0.01);

            in = in.setVariable('dh', obj.dh, 'Workspace', 'biped_robot');
            in = in.setVariable('q0_left', trajectory.q0_left, 'Workspace', 'biped_robot');
            in = in.setVariable('q0_right', trajectory.q0_right, 'Workspace', 'biped_robot');
            in = in.setVariable('angles', angles_ts, 'Workspace', 'biped_robot');
            in = in.setVariable('init_body_height', obj.body_height, 'Workspace', 'biped_robot');
            in = in.setVariable('hip_width', 0.063, 'Workspace', 'biped_robot');
            in = in.setVariable('body', obj.body, 'Workspace', 'biped_robot');
            in = in.setVariable('init_angle', trajectory.startpose.q, 'Workspace', 'biped_robot');
            
            simOut = sim(in);
            simTime = simOut.tout;
            simPosition = [simOut.yout{3}.Values.x.Data, simOut.yout{3}.Values.y.Data, simOut.yout{3}.Values.q.Data];
        end
    end
end

