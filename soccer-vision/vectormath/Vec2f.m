classdef Vec2f
    %VEC2F 2 Vector
    properties
        dx
        dy
    end
    
    methods
        function obj = Vec2f(dx,dy)
            obj.dx = dx;
            obj.dy = dy;
        end
        function theta = Angle(obj)
            theta = atan2(obj.dy,obj.dx);
        end
        function norm = Norm(obj)
            norm = sqrt(obj.dx^2 + obj.dy^2);
        end
        function unitVec = Unit(obj)
            unitVec = Vec2f(obj.dx / obj.Norm(), obj.dy / obj.Norm());
        end
        function projection = Projection(obj, obj2)
            projection = Vec2f.dot(obj, obj2.Unit());
        end
    end
    
    methods(Static)
        function val = dot(vec2f1, vec2f2)
            val = vec2f1.dx * vec2f2.dx + vec2f1.dy * vec2f2.dy;
        end
    end
end

