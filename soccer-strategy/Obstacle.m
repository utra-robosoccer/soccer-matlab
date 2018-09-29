classdef Obstacle
    %OBSTACLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pose
        obstacleType
    end
    
    methods
        function obj = Obstacle(pose,obstacleType)
            %ACTION contructs desired action
        %   OBJ = OBSTACLE(POSE, obstacleType, GOAL, DURATION)
        
            obj.pose = pose;
            obj.obstacleType = obstacleType;
        end
    end
end

