classdef findtrajectorysystem < matlab.System

    properties

    end

    properties(DiscreteState)

    end

    properties(Access = private)
        robot
    end

    methods(Access = protected)
        function setupImpl(obj)
            obj.robot = Navigation.Robot(Pose(0,0,0,0,0), Navigation.EntityType.Self, 0.10);
        end

        function trajectoryOut = stepImpl(obj, currentPose, destinationPose, obstacles)
            % currentPose = [1x1] Pose
            % destinationPose = [1x1] Pose
            % obstacles = [1xN] Pose
            
            % Test
            destPose = Pose(2.5,2.5,10,0,0);

            % Add objstacles
            obs1 = Navigation.Entity(Pose(1.3,1.3,0,0,0), Navigation.EntityType.Friendly);
            obs2 = Navigation.Entity(Pose(-1.7,1.7,0,0,0), Navigation.EntityType.Friendly);
            obs3 = Navigation.Entity(Pose(1.5,-1.5,0,0,0), Navigation.EntityType.Friendly);

            map = Navigation.Map(9, 6, 0.05);
            map.objects = {robot, obs1, obs2, obs3};
            trajectory = map.FindTrajectory(robot.pose, endPose, robot.speed);
            
            trajectoryOut = zeros(20,1000);
        end
    end
end
