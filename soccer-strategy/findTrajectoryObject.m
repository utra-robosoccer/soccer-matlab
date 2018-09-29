classdef findTrajectoryObject < matlab.System
    % findWayPointsObject Find Way Points
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function trajectoryOut = stepImpl(obj, currentPose, destinationPose, obstacles)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            
            curPose = Pose(0,0,10,0,0);
            destPose = Pose(2.5,2.5,10,0,0);

            obs1 = Pose(1.3,1.3,0,0,0);
            obs2 = Pose(-1.7,1.7,0,0,0);
            obs3 = Pose(1.5,-1.5,0,0,0);
            obstacles = {obs1, obs2, obs3};
            speed = 0.05;
            
            trajectoryOut = zeros(3000,20);
            [trajectory, ~, ~] = findTrajectory(curPose, destPose, obstacles, speed);
            trajectoryFitted = trajectory;
            trajectoryFitted = trajectoryFitted';
            [l,w] = size(trajectoryFitted);
            
            for i = 1:l
                for j = 1:w
                    trajectoryOut(l,w) = trajectoryFitted(l,w);
                end
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
