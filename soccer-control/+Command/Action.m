classdef Action < Trajectories.GeneralizedTrajectory
    %ACTION type and path that a specific action takes
    
    properties
        label
        start
        goal
        path
        stop = false %TODO: allow for specification of full stop
    end
    
    methods
        function obj = Action(label, start, goal, duration, stop)
        %ACTION contructs desired action
        %   OBJ = ACTION(LABEL, START, GOAL, DURATION)
        %   OBJ = ACTION(LABEL, START, GOAL, DURATION, STOP)
        %
        %   
        %   Arguments
        %
        %   LABEL = [1 x 1] Command.ActionLabel
        %       The type of action to perform.
        %
        %   START = [1 x 1] Pose
        %       Where the action starts.
        %
        %   GOAL = [1 x 1] Pose
        %       Where the action ends.
        %
        %   DURATION = [1 x 1]
        %       How long the action should take.
        %
        %   STOP = [1 x 1] Logical : False
        %       Whether or not the robot is expected to be stopped after
        %       the conclusion of this action.
            obj.label = label;
            obj.start = start;
            obj.goal = goal;
            obj.duration = duration;
            obj.path = Trajectories.Trajectory.plannedPath( ...
                duration, start, goal ...
            );
            if nargin > 4
                obj.stop = stop;
            end
        end
        
        function pos = positionAtTime(obj, t)            
        %POSITIONATTIME returns the position at the given team
        %   X = POSITIONATTIME(OBJ, T)
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
        %   X = [1 x 1]
        %       The position at time T
            pos = obj.path.positionAtTime(t);
        end
        
        function speed = speedAtTime(obj, t)
                    
        %SPEEDATTIME returns the speed at the given team
        %   V = SPEEDATTIME(OBJ, T)
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
        %       The speed at time T
            speed = obj.path.speedAtTime(t);
        end
    end  
end

