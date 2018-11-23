classdef Path
    %TRAJECTORY Entire Animation of the robot, including location
    
    properties
        startpose   % Start Pose of the trajectory
        endpose     % End Pose of the trajectory
        
        waypoints   % Individual points for the path
        poseactions % The paths
        animation   % Motor angles for the robot during that time
        
        states      % The current state of the robot (actionLabel type)
        
        q0_left     % Used for simulation
        q0_right    % Used for simulation
    end
    
    methods
        function obj = Path(startpose, endpose, waypoints, poseactions, angles)
            %TRAJECTORY Construct an instance of this class
            %   waypoints   [1 x N] list of Navigation.Pose
            %   poseactions [1 x N[ list of Navigation.PoseActions
            %   angles      [20 x N] trajectory
            
            obj.startpose = startpose;
            obj.endpose = endpose;
            obj.waypoints = waypoints;
            obj.poseactions = poseactions;
            obj.animation = Animation.Animation.CreateAnimation(angles, 0.01);
        end
        
        function duration = Duration(obj)
            duration = obj.animation.duration;
        end
        
        function framecount = FrameCount(obj)
            framecount = obj.animation.FrameCount;
        end
        
        function DrawPath(obj)
            obj.startpose.draw('START', 0.2);
            obj.endpose.draw('END', 0.2);
            
            for i = 1:length(obj.waypoints)
                obj.waypoints{i}.draw(num2str(i));
            end
        end
        
        function PlotAngles(obj)
            figure;
            
            % Plot the angles
            subplot(4,4,1:12);
            obj.animation.Plot;
            
            % Plot the state
            subplot(4,4,13:16); 
            plot(1:obj.FrameCount,obj.states);
            title('State')
            xlabel('Step')
            ylabel('State')
            ylim([0,5])
            grid minor;
            
            dim = [0.15 0.6 0.3 0.3];
            str = {'1: Left Swing','2: Left To Right Stance', '3: Right Swing', '4: Right To Left Stance'};
            annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor', 'white');
            
        end
        
        function dist = TotalDistance(obj)
            dist = 0;
            for i = 1:length(obj.waypoints)-1
                delta = obj.waypoints{i+1} - obj.waypoints{i};
                dist = dist + delta.length();
            end
        end
        
        function vel = AverageSpeed(obj)
            vel = obj.TotalDistance() / obj.Duration;
        end
        
        function angles = UrdfConventionAngles(obj)
            angles = obj.animation.angles;
            
            angles(1,:) = -angles(1,:);
            angles(6,:) = -angles(6,:);
        end
        
        function Publish(obj)
            % Connects to the simulation (gazebo)
            connectrobot

            jointangles = obj.UrdfConventionAngles;

            robotgoalpub = rospublisher('/robotGoal','soccer_msgs/RobotGoal');

            msg = rosmessage(robotgoalpub);

            for i = 1:length(jointangles)
                msg.Trajectories(1:12) = jointangles(1:12,i);
                robotgoalpub.send(msg)
                pause(0.01)
            end
        end
    end
end

