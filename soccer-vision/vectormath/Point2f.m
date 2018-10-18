classdef Point2f < handle
    %POINT2F Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
    end
    
    methods
        function obj = Point2f(x,y)
            obj.x = x;
            obj.y = y;
        end
        function n = norm(obj)
            n = sqrt(obj.x^2 + obj.y^2);
        end
        function v = toVector(obj)
            v = Vec2f(obj.x,obj.y);
        end
    end
end

