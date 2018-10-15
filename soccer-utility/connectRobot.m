% IP Addresses for robots
rosshutdown;

localIp = '100.64.47.75';
gazeboIp = '100.64.46.29';
robotIp = '100.64.36.165';

useRobot = 1; 

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
    device = rosdevice(gazeboIp,'vuwij','sh961013');
end