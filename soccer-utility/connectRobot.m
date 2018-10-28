
rosshutdown;
useRobot = true;

localIp = '100.64.47.75';
gazeboIp = '100.64.46.29';
robotIp = '100.64.36.165';

useRobot = 0; 
% Obtain local ip
if ismac && ~isempty(localIp)
    [~,ip] = system('ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk ''{print $2}'' ');
    localIp = strip(ip);
    fprintf('\n Local IP address is: %s \n', localIp);
elseif isunix && ~isempty(localIp)
    % Printing only. Needs testing
    system('/sbin/ifconfig eth0'); 
elseif ispc && ~isempty(localIp)
    % Printing only. Needs testing
    a=strread(evalc('!ipconfig -all'), '%s','delimiter','\n'); 
    a([strmatch('IP A',a), strmatch('IPv4 ',a)])
end

if isempty(localIp), error('Enter your computer IP address manually'); end;

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