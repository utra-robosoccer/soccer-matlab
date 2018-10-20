classdef Map
    %MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pathfindingmethod = 0; % 0 for occupancy, 1 for RRT
        occupancy
        objects
        resolution = 0.05
        height = 9 % y
        width = 6  % x
    end
    
    methods
        function obj = Map(height, width, resolution)
            %MAP Construct an instance of a map
            %   height (in dm), width in (in dm)
            obj.occupancy = zeros(height,width);
            obj.occupancy(1,:) = 1;
            obj.occupancy(end,:) = 1;
            obj.occupancy(:,1) = 1;
            obj.occupancy(:,end) = 1;
            
            obj.resolution = resolution;
        end
        
        function coordinate = FindPosition(obj, pose)
            % Returns [x, y] of the position, translating from pose to
            % coordinate
            xPose = pose.x + obj.width/2;
            yPose = pose.y + obj.height/2;

            xCor = xPose / obj.resolution;
            yCor = yPose / obj.resolution; % Use decimeters

            if xCor < 0
                xCor = 0;
            end
            if xCor > obj.width / obj.resolution - 1
                xCor = obj.width / obj.resolution - 1;
            end
            if yCor < 0
                yCor = 0;
            end
            if yCor > obj.height / obj.resolution - 1
                yCor = obj.height / obj.resolution - 1;
            end

            xCor = xCor + 1;
            yCor = yCor + 1;

            coordinate = [xCor yCor];
        end
        
        function trajectory = FindTrajectory(startPose, endPose)
            
        end
    end
end

