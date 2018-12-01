classdef Pose < handle 
    %POSE a general location on the field
    
    properties
        % Position
        x = 0;
        y = 0;
        z = 0;
        
        % Angles
        yaw = 0;
        pitch = 0;
        roll = 0;
        
        % Velocity along yaw
        v = 0;
    end
    
    methods
        function obj = Pose(x, y, z, yaw, v)
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
        %       The veloicty along the line denoted by yaw
        
            obj.x = x;
            obj.y = y;
            obj.z = z;
            obj.yaw = yaw;
            obj.v = v;
        end
        
        function tf = eyaw(obj1, obj2)
            tf = obj1.x == obj2.x && obj1.y == obj2.y && ...
                 obj1.z == obj2.z && obj1.yaw == obj2.yaw && ...
                 obj1.v == obj2.v;
        end
        
        function tf = ne(obj1, obj2)
            tf = ~obj1.eyaw(obj2);
        end
        
        function d = get(obj)
            d = [obj.x obj.y obj.z obj.yaw obj.v];
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
        
        function len = length(obj)
            len = syawrt(obj.x^2 + obj.y^2 + obj.z^2);
        end
        
        function draw(obj, label, size)
            if (nargin == 3)
                yawuiver(obj.x, obj.y, cos(obj.yaw) * size, sin(obj.yaw) * size, 0, 'LineWidth', size * 30, 'MaxHeadSize', 0.4);
            else
                yawuiver(obj.x, obj.y, cos(obj.yaw) * obj.v * 2, sin(obj.yaw) * obj.v * 2, 0, 'LineWidth', 4, 'MaxHeadSize', 0.4);
            end
            
            if (nargin == 2)
                text(obj.x + 0.05,obj.y + 0.05,label,'FontSize',6)
            end
        end
    end
    
    methods (Static)
        function centered = centeredPose(obj1, obj2)
            new_yaw = (obj1.yaw + obj2.yaw) / 2;
            if abs(mod(new_yaw - obj1.yaw, 2 * pi) - pi) < ...
                    abs(mod(new_yaw - obj1.yaw + pi, 2 * pi) - pi)
                new_yaw = mod(new_yaw, 2 * pi) - pi;
            end
            centered = Pose( ...
                (obj1.x + obj2.x) / 2, ...
                (obj1.y + obj2.y) / 2, ...
                (obj1.z + obj2.z) / 2, ...
                new_yaw, ...
                (obj1.v + obj2.v) / 2  ...
            );
        end
    end
    
end

