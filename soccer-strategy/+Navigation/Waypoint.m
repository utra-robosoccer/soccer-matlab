classdef Waypoint < Pose
    % A waypoint is a position that is on the map that occurs quite a bit
    % into the world. A navigation path contains waypoints, these waypoints
    % are then spline interpolated and creates a path
    properties
        pose
    end
    
    methods
        function obj = Waypoint(pose)
            obj.pose = pose;
        end
    end
end

