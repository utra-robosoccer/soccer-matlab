classdef Robot < Navigation.Entity

    properties
        dh % Dh table for the robot
        
        % Movement Parameters
        speed = 0.05 % m/s
        swing_time = 0.5;
        stance_time = 1.0;
        cycle_time = 2;
        step_height = 0.05;
        
        % Body Parameters
        body_height = 0.17; %0.099 + 0.16;
        body_hip_height = 0.16;
        body_hip_width = 0.07;
        
        torso_dimensions = struct('depth',0.1305, 'height', 0.152, 'width', 0.145);
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
        end
        
        function [angles, q0_left, q0_right] = CreateTrajectory(obj, poseActions, plot)
            command = Command.Command(poseActions{1}.Pose);
            command.swing_time = obj.swing_time;
            command.stance_time = obj.stance_time;
            command.cycle_time = obj.cycle_time;
            command.step_height = obj.step_height;
            command.hip_height = obj.body_hip_height;
            command.hip_width = obj.body_hip_width / 2;
            
            q0_left = command.cur_angles(1,:);
            q0_right = command.cur_angles(2,:);

            l = length(poseActions);
            totalDuration = 0;
            for i = 1:l
                p = poseActions{i};
                command.append(p.ActionLabel, p.Pose, p.Duration);
                totalDuration = totalDuration + p.Duration;
            end
            totalSteps = int16(floor(totalDuration) * 100); % 1 second to rebalance itself

            angles = zeros(12, totalSteps);
            for i = 1:(totalSteps)
                cn = command.next();
                angles(:, i) = [cn(1, :), cn(2, :)]';
            end

            if (nargin == 3)
                if (plot == 1)
                    plot((1:totalSteps), angles);
                end
            end
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
            in = in.setVariable('hip_width', obj.body_hip_width, 'Workspace', 'biped_robot');
            in = in.setVariable('body', obj.torso_dimensions, 'Workspace', 'biped_robot');
            in = in.setVariable('init_angle', trajectory.startpose.q, 'Workspace', 'biped_robot');
            
            simOut = sim(in);
            simTime = simOut.tout;
            simPosition = [simOut.yout{3}.Values.x.Data, simOut.yout{3}.Values.y.Data, simOut.yout{3}.Values.q.Data];
        end
    end
end

