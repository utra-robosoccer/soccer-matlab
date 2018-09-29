classdef Footstep < Pose & Trajectories.GeneralizedTrajectory
    %FOOTSTEP defines the position and orientation of a footstep
    
    properties
        side = Footsteps.Foot.Left;
    end
    
    methods (Hidden)
        function [x, y, q, side, time] = getParam(varargin)
        %GETPARAM allows for a default Footstep to be constructed
        %   [X, Y, Q, SIDE, TIME] = GETPARAM(VARARGIN)
        %
        %   Seperate function needed to allow for code generation. For
        %   input/output parameter specifications, see constructor.
            if nargin == 1
                x = 0; y = 0; q = 0; side = Footsteps.Foot.Left; time = 0;
            else
                x = varargin{2}; y = varargin{3}; q = varargin{4}; 
                side = varargin{5}; time = varargin{6};
            end
        end
    end
    
    methods
        function obj = Footstep(varargin)
        %FOOTSTEP Cconstructor
        %   OBJ = FOOTSTEP()
        %   OBJ = FOOTSTEP(X, Y, Q, SIDE, TIME)
        %
        %   A specific location in the global plane where the foot should
        %   fall at the end of the swing cycle.
        %
        %
        %   Arguments
        %
        %   X, Y = [1 x 1]
        %       The location of the footstep
        %
        %   Q = [1 x 1]
        %       The angle of the footstep in the x-y plane
        %
        %   SIDE = FOOT
        %       Which foot this step corresponds to
        %
        %   TIME = [1 x 1]
        %       When this footstep happens relative in body-trajectory time
            obj@Pose(0, 0, 0, 0, 0);
            [x, y, q, side, time] = obj.getParam(varargin{:});
            obj.x = x;
            obj.y = y;
            obj.q = q;
            obj.side = side;
            obj.duration = time;
        end
        
        function pos = positionAtTime(obj, t)
        %POSITIONATTIME returns the footstep at the time (constant)
        %   POS = POSITIONATTIME(OBJ, t)
        %
        %   Since footsteps are, by definition, stationary, this function
        %   simply returns the parent object.
            pos = obj;
        end
    end
end