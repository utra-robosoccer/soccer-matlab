classdef Transform < handle 
    %POSE a general location on the field
    
    properties
        % Position
        x = 0;
        y = 0;
        z = 0;
        
        % In Quaternion Format
        orientation = [0,0,0,0];
    end
    
    methods
        function obj = Transform(x, y, z, orientation)
            obj.x = x;
            obj.y = y;
            obj.z = z;
            obj.orientation = orientation;
        end
    end
end

