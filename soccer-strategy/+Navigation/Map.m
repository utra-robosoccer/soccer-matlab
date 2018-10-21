classdef Map < handle
    %MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pathfindingmethod = 0; % 0 for occupancy, 1 for RRT
        occupancy
        objects
        resolution = 0.05
        height = 9 % y
        width = 6  % x
        inflationradius = 2;
    end
    
    methods
        function obj = Map(height, width, resolution)
            %MAP Construct an instance of a map
            %   height (in dm), width in (in dm)
            obj.occupancy = zeros(height,width);
            obj.UpdateOccupancyMap();
            
            obj.resolution = resolution;
        end
        
        function AddObject(obj, object)
            % Adds a new object to the map
            obj.objects{end+1} = object;
        end
        
        function coordinate = FindCoordinate(obj, pose)
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
        
        function UpdateOccupancyMap(obj)
            % Updates the occupancy grid with the map with the objects
            
            % Zero out the occupancy grid
            for i = 1:obj.height / obj.resolution
                for j = 1:obj.width / obj.resolution
                    obj.occupancy(i,j) = 0;
                end
            end
            
            % Border of the map
            obj.occupancy(1,:) = 1;
            obj.occupancy(end,:) = 1;
            obj.occupancy(:,1) = 1;
            obj.occupancy(:,end) = 1;
            
            % Add obstacles
            for i = 1 : length(obj.objects)
                if (obj.objects{i}.type == Navigation.EntityType.Self)
                    continue
                end
                
                coord = int32(obj.FindCoordinate(obj.objects{i}.pose));
                obj.occupancy(coord(2), coord(1)) = 1;
            end
        end
        
        function [trajectory, q0_left, q0_right] = FindTrajectory(obj, startPose, endPose, speed)
            % Start Pose [1x1] Pose
            % End Pose [1x1] Pose
            
            % First find waypoints
            waypoints = obj.FindWaypoints(startPose, endPose);
            
            % Convert waypoints to pose actions
            poseactions = obj.WaypointsPoseAction(waypoints, speed);
            
            % Calculate from the pose action list
            [trajectory, q0_left, q0_right] = createtrajectory(poseactions);
        end
        
        function waypoints = FindWaypoints(obj, startpose, endpose)
            % Start Pose [1x1] Pose
            % End Pose [1x1] Pose
            
            % Update the occupancy map with the obstacles
            obj.UpdateOccupancyMap();
                        
            % Current Current Position
            startCoordinate = (obj.FindCoordinate(startpose));
            endCoordinate = (obj.FindCoordinate(endpose));
            
            % Find a path using PRM or RRT Star
            if (obj.pathfindingmethod == 0)
                mapInflated = robotics.OccupancyGrid(obj.occupancy);
                mapInflated.inflate(obj.inflationradius);
                prm = robotics.PRM(mapInflated);
                prm.NumNodes = 400;
                prm.ConnectionDistance = 20;
%                 prm.show()
                path = prm.findpath(startCoordinate, endCoordinate);
            else
                path = RRTStar(startCoordinate, endCoordinate, obj.obstacles);
            end

            % Downsample and smoothen the path
            originalSpacing = 1:length(path(:,1));
            finerSpacing = 1:0.1:length(path(:,1));
            splineXY = spline(originalSpacing, path', finerSpacing);

            % Smooth after downsampling
            pathsmooth = [movmean(splineXY(1,:),50); movmean(splineXY(2,:),50)];

            % Find the angles between each downsample
            waypoints = zeros(length(pathsmooth)-1, 5);
            for i=1:length(pathsmooth)-1
               waypoints(i,1) = pathsmooth(1,i+1);
               waypoints(i,2) = pathsmooth(2,i+1);
               waypoints(i,3) = 0;
               waypoints(i,4) = atan2(pathsmooth(2,i+1)-pathsmooth(2,i), pathsmooth(1,i+1)-pathsmooth(1,i));
               waypoints(i,5) = 0.04;
            end

            % Add start and end point
            startwaypoint = [startpose.x startpose.y startpose.z waypoints(1,4) waypoints(1,5)];
            endwaypoint = [endpose.x endpose.y endpose.z waypoints(end,4) waypoints(end,5)];

            waypoints = [startwaypoint; waypoints; endwaypoint];
        end
        
        function poseactions = WaypointsPoseAction(obj, waypoints, speed)
            [l,~] = size(waypoints);
            poseactions = cell(l,1);
            for i = 1:l
                pose = Pose(waypoints(i,1),waypoints(i,2),waypoints(i,3),waypoints(i,4),waypoints(i,5));
                actionLabel = Command.ActionLabel.Forward;
                poseactions{i} = Navigation.PoseAction(pose, actionLabel); 
                
                if (i == 1)
                    continue
                end

                xdelta = poseactions{i}.Pose.x - poseactions{i-1}.Pose.x;
                ydelta = poseactions{i}.Pose.y - poseactions{i-1}.Pose.y;
                distance = sqrt(xdelta * xdelta + ydelta * ydelta);
                poseactions{i}.Duration = distance / speed;
            end
        end
    end
end

