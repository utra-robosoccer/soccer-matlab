classdef (Abstract) GeneralizedTrajectory < handle
    %GENERALIZEDTRAJECTORY Abstract representation of a trajectory
    
    properties
        duration
    end
    
    methods
        pos = positionAtTime(obj, t)
        speed = speedAtTime(obj, t)
    end
    
end

