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
            count = floor(obj.Length() / delta);
            
            if count == 0
                dots = {};
                return;
            end
            
            d_x = (obj.p2.x - obj.p1.x) / count;
            d_y = (obj.p2.y - obj.p1.y) / count;
            d_z = (obj.p2.z - obj.p1.z) / count;
            
            for i = 1 : count
                dots{i} = Geometry.Point3f(obj.p1.x + d_x * i, obj.p1.y + d_y * i, obj.p1.z + d_z * i);
            end
            
            dots{i+1} = Geometry.Point3f(obj.p2.x, obj.p2.y, obj.p2.z);
        end
    end
end

