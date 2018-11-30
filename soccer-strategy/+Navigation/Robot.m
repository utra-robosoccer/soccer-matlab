classdef Robot < Navigation.Entity

    properties
        dh % Dh table for the robot
        
        % Movement Parameters
        speed = 0.05 % m/s
        swing_time = 0.5;
        stance_time = 1.5;
        cycle_time = 2;
        step_height = 0.05;
        step_outwards = 0.01;
        
        % Hip height while walking, higher means can not make big steps 
        % (Maximum 0.198, unable to move)
        body_hip_height = 0.180;
        
        % Height of the torso's center
        % body_hip_height + body hip to bottom of torso + torso/2 + feet/2
        body_height = 0.180 + 0.031075 + 0.152/2;
        
        % Seperation between the hips
        body_hip_width = 0.0645;
        
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
        
        function [angles, states, q0_left, q0_right] = CreateAnimation(obj, poseActions)
            command = Command.Command(poseActions{1}.Pose);
            command.swing_time = obj.swing_time;
            command.stance_time = obj.stance_time;
            command.cycle_time = obj.cycle_time;
            command.step_height = obj.step_height;
            command.hip_height = obj.body_hip_height;
            command.hip_width = obj.body_hip_width / 2;
            command.step_outwards = obj.step_outwards;
            
            q0_left = command.cur_angles(1,:);
            q0_right = command.cur_angles(2,:);

            l = length(poseActions);
            totalDuration = 0;
            for i = 1:l
                p = poseActions{i};
                command.append(p.ActionLabel, p.Pose, p.Duration);
                totalDuration = totalDuration + p.Duration;
            end
            totalSteps = int16(floor(totalDuration) * 100);

            angles = zeros(totalSteps, 18);
            states = zeros(totalSteps, 1);
            for i = 1:(totalSteps)
                [cn, states(i)] = command.next();
                angles(i, 1:12) = [cn(1, :), cn(2, :)];
            end
        end
        
        function [angles, states, q0_left, q0_right] = CreateAnimationOscillatingStance(obj, stancecount)
            ts = 0.01;
            pose = Pose(0,0,0,0,0);
            
            command = Command.Command(pose);
            command.swing_time = obj.swing_time;
            command.stance_time = obj.stance_time;
            command.cycle_time = obj.cycle_time;
            command.step_height = obj.step_height;
            command.hip_height = obj.body_hip_height;
            command.hip_width = obj.body_hip_width / 2;
            command.step_outwards = obj.step_outwards;
            
            q0_left = command.cur_angles(1,:);
            q0_right = command.cur_angles(2,:);
            
            for i = 1:stancecount
                command.append(Command.ActionLabel.StanceLeft, pose, obj.stance_time);
                command.append(Command.ActionLabel.StanceRight, pose, obj.stance_time);
            end
            
            totalDuration = stancecount * 2 * (obj.cycle_time / 2 - obj.swing_time);
            totalSteps = int16(floor(totalDuration) * (1/ts));

            angles = zeros(totalSteps, 18);
            states = zeros(totalSteps, 1);
            for i = 1:(totalSteps)
                [cn, states(i)] = command.next();
                angles(i, 1:12) = [cn(1, :), cn(2, :)];
            end
        end
        
        function [angles, states, q0_left, q0_right] = CreateAnimationOscillatingSwing(obj, foot, stancecount)
            ts = 0.01;
            pose = Pose(0,0,0,0,0);
            forwardpose = Pose(0.05,0,0,0,0);
            backwardpose = Pose(-0.05,0,0,0,0);
            
            command = Command.Command(pose);
            command.swing_time = obj.swing_time;
            command.stance_time = obj.stance_time;
            command.cycle_time = obj.cycle_time;
            command.step_height = obj.step_height;
            command.hip_height = obj.body_hip_height;
            command.hip_width = obj.body_hip_width / 2;
            command.step_outwards = obj.step_outwards;
            
            q0_left = command.cur_angles(1,:);
            q0_right = command.cur_angles(2,:);
            
            if (foot == Mechanics.Foot.Left)
%                 command.append(Command.ActionLabel.SwingLeft, forwardpose, obj.cycle_time / 2);
                command.append(Command.ActionLabel.SwingLeftBack, backwardpose, obj.cycle_time + 0.001);
            else
                command.append(Command.ActionLabel.SwingRight, forwardpose, obj.cycle_time / 2 + 0.001);
                command.append(Command.ActionLabel.SwingRightBack, backwardpose, obj.cycle_time / 2 + 0.001);
            end
            
            totalDuration = obj.cycle_time * 2;
            totalSteps = int16(floor(totalDuration) * (1/ts));

            angles = zeros(totalSteps, 18);
            states = zeros(totalSteps, 1);
            for i = 1:(totalSteps)
                [cn, states(i)] = command.next();
                angles(i, 1:12) = [cn(1, :), cn(2, :)];
            end
        end
        
        function [angles, states, q0_left, q0_right] = CreateAnimationWalking(obj, duration, speed)
            ts = 0.01;
            pose = Pose(0,0,0,0,0);
            
            command = Command.Command(pose);
            command.swing_time = obj.swing_time;
            command.stance_time = obj.stance_time;
            command.cycle_time = obj.cycle_time;
            command.step_height = obj.step_height;
            command.hip_height = obj.body_hip_height;
            command.hip_width = obj.body_hip_width / 2;
            command.step_outwards = obj.step_outwards;
            
            q0_left = command.cur_angles(1,:);
            q0_right = command.cur_angles(2,:);
            
            count = floor(duration / obj.cycle_time);
            
            for i = 1:count
                poseforward = Pose(speed / obj.cycle_time * i,0,0,0,0);
                command.append(Command.ActionLabel.Forward, poseforward, obj.cycle_time + 0.001);
            end
            
            totalSteps = int16(floor(duration) * (1/ts));

            angles = zeros(totalSteps, 18);
            states = zeros(totalSteps, 1);
            for i = 1:(totalSteps)
                [cn, states(i)] = command.next();
                angles(i, 1:12) = [cn(1, :), cn(2, :)];
            end
        end
        
        function [angles, states, q0_left, q0_right] = CreateAnimationTurningStationary(obj, duration, omega)
            ts = 0.01;
            pose = Pose(0,0,0,0,0);
            
            command = Command.Command(pose);
            command.swing_time = obj.swing_time;
            command.stance_time = obj.stance_time;
            command.cycle_time = obj.cycle_time;
            command.step_height = obj.step_height;
            command.hip_height = obj.body_hip_height;
            command.hip_width = obj.body_hip_width / 2;
            command.step_outwards = obj.step_outwards;
            
            q0_left = command.cur_angles(1,:);
            q0_right = command.cur_angles(2,:);
            
            count = floor(duration / obj.cycle_time);
            
            for i = 1:count
                poseforward = Pose(i*0.02,0,0,omega*i*2,0);
                command.append(Command.ActionLabel.Forward, poseforward, obj.cycle_time + 0.001);
            end
            
            totalSteps = int16(floor(duration) * (1/ts));

            angles = zeros(totalSteps, 18);
            states = zeros(totalSteps, 1);
            for i = 1:(totalSteps)
                [cn, states(i)] = command.next();
                angles(i, 1:12) = [cn(1, :), cn(2, :)];
            end
        end
            
        function [simTime, simPosition] = SimulateTrajectory(obj, path)
            % Trajectory = [1x1] Navigation.Trajectory
            
            load_system('biped_robot');
            in = Simulink.SimulationInput('biped_robot');
            in = in.setModelParameter('StartTime', '0', 'StopTime', num2str(path.Duration));
            in = in.setModelParameter('SimulationMode', 'Normal');

            angles_ts = path.animation.TimeSeries(1:12);

            in = in.setVariable('dh', obj.dh, 'Workspace', 'biped_robot');
            in = in.setVariable('q0_left', path.q0_left, 'Workspace', 'biped_robot');
            in = in.setVariable('q0_right', path.q0_right, 'Workspace', 'biped_robot');
            in = in.setVariable('angles', angles_ts, 'Workspace', 'biped_robot');
            in = in.setVariable('init_body_height', obj.body_height, 'Workspace', 'biped_robot');
            in = in.setVariable('hip_width', obj.body_hip_width, 'Workspace', 'biped_robot');
            in = in.setVariable('body', obj.torso_dimensions, 'Workspace', 'biped_robot');
            in = in.setVariable('init_angle', path.startpose.q, 'Workspace', 'biped_robot');
            
            simOut = sim(in);
            simTime = simOut.tout;
            simPosition = [simOut.yout{3}.Values.x.Data, simOut.yout{3}.Values.y.Data, simOut.yout{3}.Values.q.Data];
        end
    end
end

