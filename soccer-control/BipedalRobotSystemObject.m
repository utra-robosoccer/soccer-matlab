classdef BipedalRobotSystemObject < matlab.System
    % System Object used as a matlab block for path planning
    %

    % Public, tunable properties
    properties(Nontunable)
        statusUpdateTimeBeforeEnd = 5
    end

    properties(DiscreteState)
    end
    

    % Pre-computed constants
    properties(Access = private)
        command
        seconds
        angles
        angleStep
        trigStatus
    end
    methods(Access = protected)
        function setupImpl(obj)
            start_pose = Pose(0, 0, 0, 0, 0.0);
            obj.command = Command.Command(start_pose);
            obj.angles = zeros(12,2000);
            obj.angleStep = 0;
            obj.trigStatus = 0;
        end

        function [trajectories, status] = stepImpl(obj, waypoints, trigger)

            [w, l] = size(waypoints);
            
            if trigger == 0 && obj.trigStatus == 1
               obj.trigStatus = 0; 
            end
            
            if trigger == 1 && obj.trigStatus == 0
               obj.trigStatus = 1;
                if l == 6
                    obj.angleStep = obj.angleStep + w * 100 * 5;

                    for i = 1:w
                        pose = Pose(waypoints(i,1), waypoints(i,2), waypoints(i,3), waypoints(i,4),waypoints(i,5));
                        obj.command.append(Command.ActionLabel.Forward, pose, waypoints(i,6));
                    end

                    for i = 1 : (w * 100 * 5)
                         obj.command.next();
%                          obj.angles(:, i) = [cn(1, :), cn(2, :)]';
                    end
                end
            end
            
            trajectories = zeros(1,12);
            
            if obj.angleStep > 0
                trajectories = obj.angles(:,1)';
                obj.angles = [obj.angles(:,2:end), zeros(12,1)];
                obj.angleStep = obj.angleStep - 1;
            end
            
            if obj.angleStep == 1 || obj.angleStep == 0
               status = 1;
               obj.trigStatus = 0;
            else
               status = 0;
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
