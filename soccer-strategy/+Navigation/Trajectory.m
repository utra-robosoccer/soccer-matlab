classdef Trajectory
    %TRAJECTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        startpose   % Start Pose of the trajectory
        endpose     % End Pose of the trajectory
        
        waypoints   % Individual points for the path
        poseactions % The paths
        angles      % Motor angles for the robot during that time
        
        totalsteps
        duration
        
        q0_left     % Used for simulation
        q0_right    % Used for simulation
    end
    
    methods
        function obj = Trajectory(startpose, endpose, waypoints, poseactions, angles)
            %TRAJECTORY Construct an instance of this class
            %   waypoints   [1 x N] list of Navigation.Pose
            %   poseactions [1 x N] list of Navigation.PoseActions
            %   angles      [20 x N] trajectory
            
            obj.startpose = startpose;
            obj.endpose = endpose;
            obj.waypoints = waypoints;
            obj.poseactions = poseactions;
            obj.angles = angles;
            
            [~,obj.totalsteps] = size(obj.angles);
            obj.duration = obj.totalsteps / 100;
        end
        
        function DrawPath(obj)
            obj.startpose.draw('START', 0.2);
            obj.endpose.draw('END', 0.2);
            
            for i = 1:length(obj.waypoints)
                obj.waypoints{i}.draw(num2str(i));
            end
        end
        
        function PlotAngles(obj)
            plot(1:obj.totalsteps, obj.angles);
            title('Trajectory');
            xlabel('Step');
            ylabel('Angle');
            legend('Torso Left Hip Side', ...,
                'Left Hip Side Front', ...,
                'Left Hip Front Thigh', ...,
                'Left Thigh Calve', ...,
                'Left Calve Ankle', ...,
                'Left Ankle Foot', ...,
                'Torso Right Hip Side', ...,
                'Right Hip Side Front', ...,
                'Right Hip Front Thigh', ...,
                'Right Thigh Calve', ...,
                'Right Calve Ankle', ...,
                'Right Ankle Foot')
            grid minor;
        end
        
        function dist = TotalDistance(obj)
            dist = 0;
            for i = 1:length(obj.waypoints)-1
                delta = obj.waypoints{i+1} - obj.waypoints{i};
                dist = dist + delta.length();
            end
        end
        
        function vel = AverageSpeed(obj)
            vel = obj.TotalDistance() / obj.duration;
        end
        
        function duration = Duration(obj)
            duration = length(obj.angles) * 0.01;
        end
    end
end

