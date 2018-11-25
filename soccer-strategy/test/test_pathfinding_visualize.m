test_pathfinding_simulate

% Draw the visualization
close all;
f = figure('pos',[10 10 900 600]);
ax = axes('Parent',f,'position',[0.13 0.29  0.77 0.64]);
hold on;
grid minor;
map.Draw();
trajectory.DrawPath();
plot(simPose(:,1), simPose(:,2));

startTime = 0;
currentTime = 0;
endTime = trajectory.Duration;

% Create the robot
maprobot = robotics.RigidBodyTree;
basename = maprobot.BaseName;
maplink = robotics.RigidBody('map');
addBody(maprobot,maplink,basename)
robotics.Joint('test')
robot = importrobot('soccer_description/models/soccerbot/model.xacro');
addSubtree(maprobot,'map',robot)

conf = homeConfiguration(maprobot);
show(maprobot, conf,'Parent', ax);

p = uipanel(f,'Position',[0.0 0.0 1.0 0.2]);
b = uicontrol(p ,'Style','slider','Units','normalized','Position',[0.1,0.3,0.8,0.4],...
              'value',currentTime, 'min',startTime, 'max',endTime);
b.Callback = @(src,event) updateConfiguration(src, event, ax, maprobot, conf, map, trajectory, simTime, simPose); 

legend('Expected Path', 'Simulation Ground Truth')

function updateConfiguration(src, event, ax, maprobot, conf, map, trajectory, simTime, simPose)
    % Redraw original one
    cla(ax);
    map.Draw();
    trajectory.DrawPath();
    plot(simPose(:,1), simPose(:,2));

    [~, id] = min( abs(src.Value-simTime ) );
    xpos = simPose(id,1);
    ypos = simPose(id,2);
    disp(ceil(src.Value*100)+1)
    
    configangles = trajectory.angles(:,ceil(src.Value * 100)+1);
    disp(ceil(src.Value * 100)+1);
    
    conf(3).JointPosition = configangles(1);
    conf(4).JointPosition = configangles(2);
    conf(5).JointPosition = configangles(3);
    conf(6).JointPosition = configangles(4);
    conf(7).JointPosition = configangles(5);
    conf(8).JointPosition = configangles(6);
    conf(13).JointPosition = configangles(7);
    conf(14).JointPosition = configangles(8);
    conf(15).JointPosition = configangles(9);
    conf(16).JointPosition = configangles(10);
    conf(17).JointPosition = configangles(11);
    conf(18).JointPosition = configangles(12);
    disp(configangles);
    
    maprobot.getBody('map').Joint(1).setFixedTransform([1,0,0,xpos;0,1,0,ypos;0,0,1,0;0,0,0,1])
    show(maprobot, conf, 'Parent', ax);
    legend off;
end
