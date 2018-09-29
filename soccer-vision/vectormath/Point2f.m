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
    end
end

