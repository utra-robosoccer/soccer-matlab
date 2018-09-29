classdef Point3f
    %POINT3D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        z
    end
    
    methods
        function obj = Point3f(x,y,z)
            %POINT3D Construct an instance of this class
            obj.x = x;
            obj.y = y;
            obj.z = z;
        end
    end
end

