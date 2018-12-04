classdef Point3f < handle
    %POINT2F Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        z
    end
    
    methods
        function obj = Point3f(x,y,z)
            obj.x = x;
            obj.y = y;
            obj.z = z;
        end
        function n = norm(obj)
            n = sqrt(obj.x^2 + obj.y^2 + obj.z^2);
        end
        function Draw(obj)
            plot3([obj.x], [obj.y], [obj.z], '+')
        end
    end
end

