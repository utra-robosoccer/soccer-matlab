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
            v = Geometry.Vec2f(obj.x,obj.y);
        end
        function Draw(obj)
            plot(obj.x, obj.y, '+')
        end
    end
    methods (Static)
        function dist = Distance(p1, p2)
            dist = sqrt((p2.y - p1.y) ^ 2 + (p2.x - p1.x) ^ 2);
        end
    end
end

