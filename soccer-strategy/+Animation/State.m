classdef State
    %STATE Summary of this class goes here
    
    properties
        angles
    end
    
    methods
        function obj = State(angles)
            obj.angles = angles;
        end
        
        function angles = UrdfConventionAngles(obj)
            angles = obj.angles;
        end
        
        function Publish(obj, duration)
            if (nargin == 1)
                duration = 1;
            end
            
            % Connects to the simulation (gazebo)
            connectrobot

            jointangles = obj.UrdfConventionAngles;

            robotgoalpub = rospublisher('/robotGoal','soccer_msgs/RobotGoal');

            msg = rosmessage(robotgoalpub);

            for i = 1 : duration / 0.01
                msg.Trajectories(1:18) = jointangles(1:18);
                robotgoalpub.send(msg)
                pause(0.01)
            end
        end
    end
end

