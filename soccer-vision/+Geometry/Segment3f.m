classdef Segment3f < handle
    %LINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        p1
        p2
    end
    
    methods
        function obj = Segment3f(p1,p2)
            %LINE Construct an instance of this class
            %   Detailed explanation goes here
            obj.p1 = p1;
            obj.p2 = p2;
        end
        function Draw(obj)
            plot3([obj.p1.x obj.p2.x], [obj.p1.y obj.p2.y], [obj.p1.z obj.p2.z])
        end
    end
end

