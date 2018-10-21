classdef PoseAction < handle
    % Consists of a pose (from control and an action)
    
    properties
        ActionLabel
        Pose
        Duration = 0;
    end
    
    methods
        function obj = PoseAction(pose, actionLabel, duration)
            obj.Pose = pose;
            obj.ActionLabel = actionLabel;
            
            if (nargin == 3)
                obj.Duration = duration;
            end
        end
    end
end

