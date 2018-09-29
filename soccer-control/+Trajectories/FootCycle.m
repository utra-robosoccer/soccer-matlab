classdef FootCycle < Trajectories.GeneralizedTrajectory
    %FOOTCYCLE A full cycle (swing - stance) for one foot
    % TODO Replace all usage with direct LiveQueue <- almost identical use
    
    properties (Hidden)
        stance
        swing
        trans_time;
    end
    
    methods
        function obj = FootCycle(body_traj, last_step, next_step, ...
                step_height, trans_time, duration)
        %FOOTCYCLE Constructor
        %   OBJ = FOOTCYCLE(BODY_TRAJ, LAST_STEP, NEXT_STEP, STEP_HEIGHT,
        %       CUR_TIME, TRANS_TIME, DURATION)
        %
        %   Combines the stance and swing phases for one cycle for ease
        %
        %
        %   Arguments
        %
        %   BODY_TRAJ = Trajectory
        %       The idealized path that the body will follow
        %
        %   LAST_STEP, NEXT_STEP = Footstep
        %       The initial and final position for the foot
        %
        %   STEP_HEIGHT = [1 x 1]
        %       The peak height of the step
        %
        %   CUR_TIME, TRANS_TIME, DURATION = [1 x 1]
        %       The current time, the time of transition to stance phase,
        %       and the total duration of this cycle.
        
            obj.trans_time = trans_time;
            obj.duration = duration;
            
            % Determine initial, transition, and final speeds
            init_pos    = last_step - body_traj.positionAtTime(0);
            trans_pos   = next_step - body_traj.positionAtTime(trans_time);
            fin_pos     = next_step - body_traj.positionAtTime(duration);
            init_speed  = body_traj.speedAtTime(0);
            trans_speed = body_traj.speedAtTime(trans_time);
            fin_speed   = body_traj.speedAtTime(duration);
            
            % If there exists a swing phase, construct swing trajectory
            obj.swing = Trajectories.Trajectory.footTrajectory(trans_time, ...
                init_pos, trans_pos, init_speed, trans_speed, step_height);
            % If there exists a stance phase, construct stance trajectory
            obj.stance = Trajectories.Trajectory.footTrajectory(duration - trans_time, ...
                trans_pos, fin_pos, trans_speed, fin_speed, 0);
        end
        
        function pos = positionAtTime(obj, t)
        %POSITIONATTIME returns the position at the given time
        %   X = POSITIONATTIME(OBJ, T)   
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
            if t < obj.trans_time
                pos = obj.swing.positionAtTime(t);
            else
                pos = obj.stance.positionAtTime(t - obj.trans_time);
            end
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
        %       The speed at time t
            if t < obj.trans_time
                speed = obj.swing.speedTime(t);
            else
                speed = obj.stance.speedTime(t - obj.trans_time);
            end
        end
    end
    
end

