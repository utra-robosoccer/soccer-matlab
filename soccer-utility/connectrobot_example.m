%% Connects the matlab to the robot
% make a copy and rename this file to connectrobot.m

% IP Addresses for robots
rosshutdown;

localIp  = getipaddress();    % IP address of your computer (ifconfig)
gazeboIp = '172.16.10.19';    % IP address of gazebo simulator computer
robotIp  = '100.64.36.165';   % IP address of robot

useRobot = 0; 

if useRobot
    setenv('ROS_IP', localIp)
    setenv('ROS_MASTER_URI',strcat('http://', robotIp, ':11311'))
    rosinit(robotIp, 'NodeHost', localIp)
%     device = rosdevice(robotIp, 'nvidia', 'nvidia');
%     device.ROSFolder = '/opt/ros/kinetic';
%     device.CatkinWorkspace = '~/catkin_ws';
else
    setenv('ROS_IP', localIp)
    setenv('ROS_MASTER_URI',strcat('http://', gazeboIp, ':11311'))
    rosinit(gazeboIp, 'NodeHost', localIp)
end