classdef PoseAction < handle
    % Consists of a pose (from control and an action)
    
    properties
        ActionLabel
        Duration
        Pose
    end
    
    methods
        function obj = PoseAction(pose, actionLabel, duration)
            obj.Pose = pose;
            obj.ActionLabel = actionLabel;
            obj.Duration = duration;
        end
    end
end

