classdef findtrajectorysystem < matlab.System & matlab.system.mixin.Propagates

    properties
        outputduration = 100;            % Seconds
    end

    properties(DiscreteState)
    end

    properties(Access = private)
        robot;
        trajectory;
        states;
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            obj.robot = Navigation.Robot(Pose(0,0,0,0,0), Navigation.EntityType.Self, 0.05);
            obj.trajectory = zeros(10000,20);    % Output max trajectory
            obj.states = zeros(10000,1);
        end

        function [trajectory, states] = stepImpl(obj, currentPose, destinationPose, obstacles)
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
            traj = map.FindPath(obj.robot, endPose, obj.robot.speed);
                        
            % Fill in the trajectory
            [l,w] = size(traj.animation.trajectory);
            
            obj.trajectory(1:l,1:w) = traj.animation.trajectory(1:l,1:w);
            obj.states(1:l) = traj.states(1:l);
            
            obj.trajectory(1:l,1) = -obj.trajectory(1:l,6);
            obj.trajectory(1:l,6) = -obj.trajectory(1:l,6);
            
            trajectory = obj.trajectory;
            states = obj.states;
        end
        
        function [c1, c2] = isOutputFixedSizeImpl(~)
            c1 = true;
            c2 = true;
        end
        function [sz_1, sz_2] = getOutputSizeImpl(obj)
            sz_1 = [obj.outputduration * 100 20];
            sz_2 = [obj.outputduration * 100 1];
        end 
        function [out1, out2] = getOutputDataTypeImpl(~)
            out1 = "double";
            out2 = "double";
        end
        function [c1, c2] = isOutputComplexImpl(~)
            c1 = false;
            c2 = false;
        end
    end
end
