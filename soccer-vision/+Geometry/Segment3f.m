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
        function len = Length(obj)
            len = sqrt( (obj.p1.x - obj.p2.x)^2 + (obj.p1.y - obj.p2.y)^2 + (obj.p1.z - obj.p2.z)^2 );
        end
        function dots = ConvertToDots(obj, delta)
            dots = {};
            counts = obj.Length() / delta;
            d_x = (obj.p2.x - obj.p1.x) / counts;
            d_y = (obj.p2.y - obj.p1.y) / counts;
            d_z = (obj.p2.z - obj.p1.z) / counts;
            index = 1;
            for i=0:counts
                dots{index} = Geometry.Point3f(obj.p1.x + d_x * i, obj.p1.y + d_y * i, obj.p1.z + d_z * i);
                index = index + 1;
            end
            dots{index} = Geometry.Point3f(obj.p2.x, obj.p2.y, obj.p2.z);
        end
    end
end

