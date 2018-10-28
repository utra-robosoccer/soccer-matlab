classdef Entity
    %OBSTACLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pose
        type
    end
    
    methods
        function obj = Entity(pose, type)
            %ACTION contructs desired action
        %   OBJ = OBSTACLE(POSE, obstacleType, GOAL, DURATION)
            obj.pose = pose;
            obj.type = type;
        end
    end
end

