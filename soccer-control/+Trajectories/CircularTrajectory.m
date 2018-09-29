classdef BezierTrajectory < Trajectories.GeneralizedTrajectory
%BEZIERTRAJECTORY Defines a general purpose 1D bezier trajectory
    
    properties
        order = 0;
        parameters = [];
        cur_time = 0.0;
        secant_size = 0.001;
        end_pos = 0;
        end_vel = 0;
    end
    
    methods
        function obj = BezierTrajectory(duration, varargin)
        %BEZIERTRAJECTORY creates a bezier trajectory between points
        %    OBJ = BEZIERTRAJECTORY(DURATION, INI_POS, FIN_POS, INI_VEL, FIN_VEL)
        %    OBJ = BEZIERTRAJECTORY(DURATION, INI_POS, FIN_POS, INI_VEL, FIN_VEL, HEIGHT)
        %
        %   Produces a one-dimensional Bezier trajectory based on the
        %   provided boundary conditions. Currently supports third and
        %   fourth order Bezier curves.
        %
        %
        %   Arguments
        %
        %   DURATION = [1 x 1]
        %       The time to move between the two positions
        %
        %   PREV_POS, NEXT_POS = [1 x 1]
        %       The starting and ending positions of the foot in the x-axis
        %
        %   PREV_SPEED, NEXT_SPEED = [1 x 1]
        %       The starting and ending speeds of the foot in the x-axis
        %
        %   HEIGHT = [1 x 1]
        %       The peak height during mid-swing of the cycle
        
            if nargin > 0
                obj.order = length(varargin) - 1;
                obj.duration = duration;
                obj.end_pos = varargin{2};
                if nargin == 5 % Order 3
                    obj.parameters = [varargin{1}, ...
                        3*varargin{1} + varargin{3}*duration, ...
                        3*varargin{2} - varargin{4}*duration, ...
                        varargin{2}];
                elseif nargin == 6 % Order 4
                    obj.parameters = [varargin{1}, ...
                        4*varargin{1} + varargin{3}*duration, ...
                        0 , ...
                        4*varargin{2} - varargin{4}*duration, ...
                        varargin{2}];
                    obj.parameters(3) = (16*varargin{5} - ...
                        obj.parameters(1) - obj.parameters(2) - ...
                        obj.parameters(4) - obj.parameters(5));
                else
                    error(['Undefined Bezier Order: Please check input ' ...
                        'arguments or add a new definition'])
                end
                obj.end_vel = obj.speedAtTime(obj.duration);
            end
        end
        
        function x = positionAtTime(obj, t)
            %POSITIONATTIME returns the position at time t
            %   X = POSITIONATTIME(OBJ, T)
            %
            %   Gives the position at the specified time. Can be vectorized, 
            %   producing a list of positons correspoinding to the array of t   
            %
            %
            %   Arguments
            %
            %   T = [1 x 1]
            %       The time to retrieve the positon at
            %
            %
            %   Outputs
            %
            %   X = [1 x 1]
            %       The position at time t
            
            x = 0;
            if t >= obj.duration
                % Linear extrapolation of the position
                x = obj.end_pos + obj.end_vel * (t - obj.duration);
                return
            end
            
            % Evaluate the Bezier function per parameter
            for i = 0:obj.order
                x = x + obj.parameters(i+1) * ...
                (obj.duration - t).^(obj.order-i) .* t.^i;
            end
            x = x ./ obj.duration^obj.order;
        end
        
        function v = speedAtTime(obj, t)            
        %SPEEDATTIME returns the speed at time t
        %   V = SPEEDATTIME(OBJ, T)
        %
        %   Gives the speed at the specified time. Can be vectorized, 
        %   producing a list of speeds correspoinding to the array of t.
        %   Note that the speed is created by a centered secant based on
        %   the secant_size parameter of the class.
        %
        %
        %   Arguments
        %
        %   T = [1 x 1]
        %       The time to retrieve the speed at
        %
        %
        %   Outputs
        %
        %   V = [1 x 1]
        %       The speed at time t
            if t > obj.duration
                v = obj.end_vel;
                return
            end
            tp = min(t + obj.secant_size, obj.duration);
            tm = max(t - obj.secant_size, 0);
            v = (obj.positionAtTime(tp) - obj.positionAtTime(tm))./(tp - tm);
        end
    end
end

