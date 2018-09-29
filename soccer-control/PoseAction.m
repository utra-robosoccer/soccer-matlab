classdef PoseAction < handle
    
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

