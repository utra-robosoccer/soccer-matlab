clear; close all; clc;

% Load images
load('soccer-vision/data/lines_data.mat');
rhos = squeeze(rhos.Data);
thetas = squeeze(thetas.Data);
counts = squeeze(counts.Data); 

[l,w] = size(rhos);

camimg = Camera.Image(240,360);
segments = cell(0,w);

for i = 1:w
    lines = Geometry.Line2f.empty(counts(i),0);
    for j = 1:counts(i)
        lines(j) = Geometry.Line2f.ImgConvention(rhos(j,i), thetas(j,i), 240);
    end
    segments{i} = camimg.TrimLines(lines);
end

%% Camera Raytrace
t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([deg2rad(45),deg2rad(45),0]));
camera = Camera.Camera(t, 240, 360);
camera.Draw();
hold on;
camera.DrawPixelRayTrace(120, 180);
camera.DrawPixelRayTrace(0, 0);
camera.DrawPixelRayTrace(240, 360);
camera.DrawPixelRayTrace(240, 0);
camera.DrawPixelRayTrace(0, 360);

%% Plot the image onto the camera

% TODO
t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([deg2rad(45),deg2rad(45),0]));
camera = Camera.Camera(t, 240, 360);
camera.Draw();

cla;
hold on;
p3d1 = camera.FindFloorCoordinate(0,0);
p3d2 = camera.FindFloorCoordinate(0,100);
seg = Geometry.Segment3f(p3d1,p3d2);
seg.Draw();

p3d1 = camera.FindFloorCoordinate(100,100);
p3d2 = camera.FindFloorCoordinate(0,100);
seg = Geometry.Segment3f(p3d1,p3d2);
seg.Draw();

p3d1 = camera.FindFloorCoordinate(100,100);
p3d2 = camera.FindFloorCoordinate(100,0);
seg = Geometry.Segment3f(p3d1,p3d2);
seg.Draw();

p3d1 = camera.FindFloorCoordinate(0,0);
p3d2 = camera.FindFloorCoordinate(100,0);
seg = Geometry.Segment3f(p3d1,p3d2);
seg.Draw();


%% Plot the TEST

% TODO
t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([deg2rad(0),deg2rad(25),0]));
camera = Camera.Camera(t, 240, 360);
camera.Draw();

% 2,171
% 75,95
% 264,94
% 323,143


cla;
hold on;
p3d1 = camera.FindFloorCoordinate(75,95);
p3d2 = camera.FindFloorCoordinate(264,94);
seg = Geometry.Segment3f(p3d1,p3d2);
seg.Draw();

p3d1 = camera.FindFloorCoordinate(2,171);
p3d2 = camera.FindFloorCoordinate(75,95);
seg = Geometry.Segment3f(p3d1,p3d2);
seg.Draw();

p3d1 = camera.FindFloorCoordinate(264,94);
p3d2 = camera.FindFloorCoordinate(323,143);
seg = Geometry.Segment3f(p3d1,p3d2);
seg.Draw();

%p3d1 = camera.FindFloorCoordinate(323,143);
%p3d2 = camera.FindFloorCoordinate(2,171);
%seg = Geometry.Segment3f(p3d1,p3d2);
%seg.Draw();



%% Plot the image onto the camera

% TODO
%t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([deg2rad(45),deg2rad(45),0]));
t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([deg2rad(0),deg2rad(25),0]));
camera = Camera.Camera(t, 240, 360);
camera.Draw();
for i=1:length(segments)
    cla;
    hold on;
    for j=1:length(segments{i})
        p3d1 = camera.FindFloorCoordinate(segments{i}{j}.p1.x,240 - segments{i}{j}.p1.y);
        p3d2 = camera.FindFloorCoordinate(segments{i}{j}.p2.x,240 - segments{i}{j}.p2.y);
        
        seg = Geometry.Segment3f(p3d1,p3d2);
        seg.Draw();
        %camera.DrawPixelRayTrace(segments{i}{j}.p1.x,segments{i}{j}.p1.y);
        %camera.DrawPixelRayTrace(segments{i}{j}.p2.x,segments{i}{j}.p2.y);
    end
    pause(0.03);
end
%% Break all the lines into points and plot them

% TODO
%t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([deg2rad(45),deg2rad(45),0]));
t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([deg2rad(0),deg2rad(25),0]));
camera = Camera.Camera(t, 240, 360);
camera.Draw();
step_size = 0.1;
for i=1:length(segments)
    cla;
    hold on;
    camera.DrawPixelRayTrace(120, 180);
    camera.DrawPixelRayTrace(0, 0);
    camera.DrawPixelRayTrace(240, 360);
    camera.DrawPixelRayTrace(240, 0);
    camera.DrawPixelRayTrace(0, 360);
    for j=1:length(segments{i})
        p3d1 = camera.FindFloorCoordinate(segments{i}{j}.p1.x,240 - segments{i}{j}.p1.y);
        p3d2 = camera.FindFloorCoordinate(segments{i}{j}.p2.x,240 - segments{i}{j}.p2.y);
        seg = Geometry.Segment3f(p3d1,p3d2);
        
        dots = seg.ConvertToDots(0.3);
        for k=1:length(dots)
            dots{k}.Draw();
        end
        
        % seg.Draw();
        %camera.DrawPixelRayTrace(segments{i}{j}.p1.x,segments{i}{j}.p1.y);
        %camera.DrawPixelRayTrace(segments{i}{j}.p2.x,segments{i}{j}.p2.y);
    end
    pause(0.01);
end
