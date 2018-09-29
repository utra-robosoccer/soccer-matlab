classdef Segment3f < handle
    %LINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        p1
        p2
    end
    
    methods
        function obj = Segment3f(p1, p2)
            %LINE Construct an instance of this class
            obj.p1 = p1;
            obj.p2 = p2;
        end
    end
end

