classdef Robot < Object

    properties
        dh % Dh table for the robot
        speed = 0.05 % m/s
    end
    
    methods
        function obj = Robot(speed)
            %ROBOT Construct an instance of this class
            obj.speed = speed;
        end
    end
end

