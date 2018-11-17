classdef findtrajectorysystem < matlab.System & matlab.system.mixin.Propagates

    properties
        outputduration = 100;            % Seconds
    end

    properties(DiscreteState)
    end

    properties(Access = private)
        robot;
        trajectory;
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            obj.robot = Navigation.Robot(Pose(0,0,0,0,0), Navigation.EntityType.Self, 0.05);
            obj.trajectory = zeros(10000,20);    % Output max trajectory

        end

        function trajectoryOut = stepImpl(obj, currentPose, destinationPose, obstacles)
            % currentPose = [1x1] Pose
            % destinationPose = [1x1] Pose
            % obstacles = [1xN] Pose
            
            % Test
            endPose = Pose(2.5,2.5,10,0,0);

            % Add obstacles
            obs1 = Navigation.Entity(Pose(1.3,1.3,0,0,0), Navigation.EntityType.Friendly);
            obs2 = Navigation.Entity(Pose(-1.7,1.7,0,0,0), Navigation.EntityType.Friendly);
            obs3 = Navigation.Entity(Pose(1.5,-1.5,0,0,0), Navigation.EntityType.Friendly);

            map = Navigation.Map(9, 6, 0.05);
            map.objects = {obj.robot, obs1, obs2, obs3};
            traj = map.FindTrajectory(obj.robot, endPose, obj.robot.speed);
                        
            % Fill in the trajectory
            [l,w] = size(traj.angles);
            for i = 1:w
                for j = 1:l
                    obj.trajectory(i,j) = traj.angles(j,i);
                end
            end
            
            obj.trajectory(:,1) = -obj.trajectory(:,1);
            obj.trajectory(:,6) = -obj.trajectory(:,6);
            
            trajectoryOut = obj.trajectory;
        end
        
        function c1 = isOutputFixedSizeImpl(~)
            c1 = true;
        end
        function sz_1 = getOutputSizeImpl(obj)
            sz_1 = [obj.outputduration * 100 20];
        end 
        function out = getOutputDataTypeImpl(~)
            out = "double";
        end
        function c1 = isOutputComplexImpl(~)
            c1 = false;
        end
    end
end
