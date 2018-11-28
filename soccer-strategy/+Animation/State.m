classdef State
    %STATE Summary of this class goes here
    
    properties
        angles
        calibration
    end
    
    methods
        function obj = State(angles, calibration)
            obj.angles = angles;
            
            if (nargin == 2)
                obj.calibration = calibration;
            else
                obj.calibration = zeros(1,20);
            end
        end
        
        function calibratedangles = CalibratedAngles(obj)
            calibratedangles = obj.angles + obj.calibration;
        end
        
        function angles = UrdfConventionAngles(obj)
            angles = obj.CalibratedAngles;
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

