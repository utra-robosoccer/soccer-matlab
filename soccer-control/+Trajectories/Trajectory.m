classdef Trajectory < Trajectories.GeneralizedTrajectory
    %TRAJECTORY Defines a ND Bezier trajectory through space
    
    properties (Hidden)
        data
    end
    
    methods
        function pos = positionAtTime(obj, t)
        %POSITIONATTIME produces the positions at time t
            p = zeros(1, 5);
            for i = 1:5
                p(i) = obj.data{i}.positionAtTime(t);
            end
            pos = Pose(p(1), p(2), p(3), p(4), p(5));
        end
        function speed = speedAtTime(obj, t)
        %SPEEDATTIME produces the speeds at time t
            s = zeros(1, 5);
            for i = 1:5
                s(i) = obj.data{i}.speedAtTime(t);
            end
            speed = Pose(s(1), s(2), s(3), s(4), s(5));
        end
    end
    
    methods(Static)
        function obj = footTrajectory(duration, ...
                prev_pos, next_pos, prev_speed, next_speed, height)
        %FOOTTRAJECTORY Produces a forward an vertical trajectory for foot
        %   OBJ = FOOTTRAJECTORY(DURATION, PREV_POS, NEXT_POS, PREV_SPEED, NEXT_SPEED, HEIGHT)
        %
        %   This produces the path that the foot will follow across one
        %   cycle (stance or swing. A stance cycle will simply have height
        %   of 0. Does not model off-axis movement of the foot.
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

            %Ensure continuous rotations
            iq = mod(prev_pos.q, 2*pi); fq = mod(next_pos.q, 2*pi);
            if abs(fq - iq) > pi
                if abs(fq) > abs(iq)
                    fq = fq - 2 * pi;
                else
                    iq = iq - 2 * pi;
                end
            end
        
            obj = Trajectories.Trajectory();
            obj.duration = duration;
            obj.data = {
                Trajectories.BezierTrajectory(duration, ...
                    prev_pos.x, next_pos.x, -prev_speed.x, -next_speed.x);
                Trajectories.BezierTrajectory(duration, ...
                    prev_pos.y, next_pos.y, -prev_speed.y, -next_speed.y);
                Trajectories.BezierTrajectory(duration, ...
                    0, 0, 0, 0, height);
                Trajectories.BezierTrajectory(duration, ...
                    iq, fq, -prev_speed.q, -next_speed.q);
                Trajectories.BezierTrajectory(duration, ...
                    prev_pos.v, next_pos.v, -prev_speed.v, -next_speed.v)
            };
        end
        
        function obj = plannedPath(duration, prev_pose, next_pose)
        %PLANNEDPATH Produces a planar trajectory for body
        %   OBJ = PLANNEDPATH(DURATION, PREV_POS, NEXT_POS)
        %
        %   This produces the path that the body will follow based on an 
        %   inital and final Pose.
        %
        %
        %   Arguments
        %
        %   DURATION = [1 x 1]
        %       The time to move between the two positions
        %
        %   PREV_POS, NEXT_POS = Pose
        %       The starting and ending poses of the body
        
            obj = Trajectories.Trajectory();
            obj.duration = duration;
            obj.data = {
                Trajectories.BezierTrajectory(duration, prev_pose.x, next_pose.x, ...
                    prev_pose.v*cos(prev_pose.q), next_pose.v*cos(next_pose.q));
                Trajectories.BezierTrajectory(duration, prev_pose.y, next_pose.y, ...
                    prev_pose.v*sin(prev_pose.q), next_pose.v*sin(next_pose.q));
                Trajectories.BezierTrajectory(duration, prev_pose.z, next_pose.z, 0, 0);
                Trajectories.BezierTrajectory(duration, prev_pose.q, next_pose.q, 0, 0);
                Trajectories.BezierTrajectory(duration, prev_pose.v, next_pose.v, 0, 0)
            };
        end
    end
    
end

