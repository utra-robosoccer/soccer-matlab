classdef Map < handle
    %MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pathfindingmethod = 0; % 0 for occupancy, 1 for RRT
        occupancymap
        objects = {};
        resolution = 0.05;
        height = 9; % y (meters)
        width = 6;  % x (meters)
        inflationradius = 0.2; % 20 cm
        numnodes = 2000; % Number of spots on map
        connectiondistance = 0.4; % 30 cm
    end
    
    methods
        function obj = Map(height, width, resolution)
            %MAP Construct an instance of a map
            %   height (in dm), width in (in dm)
            obj.height = height;
            obj.width = width;
            obj.resolution = resolution;
            
            obj.UpdateOccupancyMap();
        end
        
        function AddObject(obj, object)
            % Adds a new object to the map
            obj.objects{end+1} = object;
        end
        
        function Draw(obj, includePRM)
            obj.UpdateOccupancyMap();
            
            if (nargin == 1 || ~includePRM)
                obj.occupancymap.show();
            end
            
            if (nargin == 2 && includePRM)
                prm = robotics.PRM(obj.occupancymap);
                prm.NumNodes = obj.numnodes;
                prm.ConnectionDistance = obj.connectiondistance;
                prm.show();
            end 
        end
        
        function UpdateOccupancyMap(obj)
            % Updates the occupancy grid with the map with the objects
            
            % Zero out the occupancy grid
            occupancygrid = zeros(obj.height / obj.resolution, obj.width / obj.resolution);
            for i = 1:obj.height / obj.resolution
                for j = 1:obj.width / obj.resolution
                    occupancygrid(i,j) = 0;
                end
            end
            
            % Border of the map
            occupancygrid(1,:) = 1;
            occupancygrid(end,:) = 1;
            occupancygrid(:,1) = 1;
            occupancygrid(:,end) = 1;
            
            % Create Map
            obj.occupancymap = robotics.OccupancyGrid(occupancygrid, 1/obj.resolution);
            obj.occupancymap.GridLocationInWorld = [-obj.width/2,-obj.height/2];

            for i = 1:length(obj.objects)
                if (obj.objects{i}.type == Navigation.EntityType.Self)
                    continue
                end
                obj.occupancymap.setOccupancy([obj.objects{i}.pose.x, obj.objects{i}.pose.y], 1.0);
            end
            obj.occupancymap.inflate(obj.inflationradius);
            
        end
        
        function trajectory = FindTrajectory(obj, startPose, endPose, speed)
            % Start Pose [1x1] Pose
            % End Pose [1x1] Pose
            
            % First find waypoints
            waypoints = obj.FindWaypoints(startPose, endPose, speed);
            
            % Convert waypoints to pose actions
            poseactions = obj.WaypointsPoseAction(waypoints, speed);
            
            % Calculate from the pose action list
            [angles, q0_left, q0_right] = createtrajectory(poseactions);
            
            % Clip off bad angles
            
            trajectory = Navigation.Trajectory(startPose, endPose, waypoints, poseactions, angles);
            trajectory.q0_left = q0_left;
            trajectory.q0_right = q0_right;
        end
        
        function waypoints = FindWaypoints(obj, startpose, endpose, speed)
            % Start Pose [1x1] Pose
            % End Pose [1x1] Pose
            
            % Update the occupancy map with the obstacles
            obj.UpdateOccupancyMap();
                        
            % Current Current Position
            startCoordinate = [startpose.x, startpose.y];
            endCoordinate = [endpose.x, endpose.y];
            
            % Find a path using PRM or RRT Star
            if (obj.pathfindingmethod == 0)
                prm = robotics.PRM(obj.occupancymap);
                prm.NumNodes = obj.numnodes;
                prm.ConnectionDistance = obj.connectiondistance;
                path = prm.findpath(startCoordinate, endCoordinate);
            else
                path = RRTStar(startCoordinate, endCoordinate, obj.obstacles);
            end
            
            % Adjust some waypoints to even path
            if (length(path) > 6)
                path(2,:) = [];
                path(3,:) = [];
                path(end,:) = [];
            end
            
            % Find the angles between each downsample
            waypoints = cell(length(path)-1, 1);
            for i = 1:length(path) - 1
                waypoints{i} = Pose(path(i,1), path(i,2), 0, ...
                    atan2(path(i+1,2)-path(i,2), path(i+1,1) - path(i,1)), speed);
            end

        end
        
        function poseactions = WaypointsPoseAction(obj, waypoints, speed)
            [l,~] = size(waypoints);
            poseactions = cell(l,1);
            for i = 1:l
                actionLabel = Command.ActionLabel.Forward;
                poseactions{i} = Navigation.PoseAction(waypoints{i}, actionLabel); 
                
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
