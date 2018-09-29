classdef Pose < handle
    %POSE a general location on the field
    
    properties
        % Position
        x = 0;
        y = 0;
        z = 0;
        % Angle in the x-y plane measured ccw from positive x
        q = 0;
        % Velocity along q
        v = 0;
    end
    
    methods
        function obj = Pose(x, y, z, q, v)
        %POSE Constructor
        %   OBJ = POSE()
        %   OBJ = POSE(X, Y, Z, Q, V)
        %
        %
        %   Arguments
        %   
        %   X, Y, Z = [1 x 1]
        %       The coordinates on the field
        %
        %   Q = [1 x 1]
        %       The angle in the x-y plane ccw from positive x
        %
        %   V = [1 x 1]
        %       The veloicty along the line denoted by q
        
            obj.x = x;
            obj.y = y;
            obj.z = z;
            obj.q = q;
            obj.v = v;
        end
        
        function tf = eq(obj1, obj2)
            tf = obj1.x == obj2.x && obj1.y == obj2.y && ...
                 obj1.z == obj2.z && obj1.q == obj2.q && ...
                 obj1.v == obj2.v;
        end
        
        function tf = ne(obj1, obj2)
            tf = ~obj1.eq(obj2);
        end
        
        function d = get(obj)
            d = [obj.x obj.y obj.z obj.q obj.v];
        end
        
        function r = uplus(obj)
            r = obj;
        end
        
        function r = uminus(obj)
            d = -obj.get();
            r = Pose(d(1), d(2), d(3), d(4), d(5));
        end
        
        function r = plus(obj1, obj2)
            d = obj1.get() + obj2.get();
            r = Pose(d(1), d(2), d(3), d(4), d(5));
        end
        
        function r = minus(obj1, obj2)
            r = obj1 + -obj2;
        end
        
        function t = isobject(obj)
            t = true;
        end
    end
    
    methods (Static)
        function centered = centeredPose(obj1, obj2)
            new_q = (obj1.q + obj2.q) / 2;
            if abs(mod(new_q - obj1.q, 2 * pi) - pi) < ...
                    abs(mod(new_q - obj1.q + pi, 2 * pi) - pi)
                new_q = mod(new_q, 2 * pi) - pi;
            end
            centered = Pose( ...
                (obj1.x + obj2.x) / 2, ...
                (obj1.y + obj2.y) / 2, ...
                (obj1.z + obj2.z) / 2, ...
                new_q, ...
                (obj1.v + obj2.v) / 2  ...
            );
        end
    end
    
end

