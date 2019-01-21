clear; close all; clc;

%% Just draw the camera moving the camera around
close all;

for i = 0:0.2:180
    cla;
    t = Geometry.Transform([-0.5, -0.5, 0.5], eul2quat([deg2rad(45),deg2rad(i),0]));
    camera = Camera.Camera(t, 240, 360);
    camera.Draw();
    pause(0.03);
end

%% Draw a square on the camera

t = Geometry.Transform([-0.5, -0.5, 0.5], eul2quat([deg2rad(45),deg2rad(45),0]));
camera = Camera.Camera(t, 240, 360);
camera.Draw();

hold on;
p1 = camera.FindFloorCoordinate(180-50,120-50);
p2 = camera.FindFloorCoordinate(180-50,120+50);
p3 = camera.FindFloorCoordinate(180+50,120+50);
p4 = camera.FindFloorCoordinate(180+50,120-50);

seg1 = Geometry.Segment3f(p1,p2);
seg2 = Geometry.Segment3f(p2,p3);
seg3 = Geometry.Segment3f(p3,p4);
seg4 = Geometry.Segment3f(p4,p1);

seg1.Draw();
seg2.Draw();
seg3.Draw();
seg4.Draw();

%% Plot the image onto the camera

% Load images
load('soccer-vision/data/lines_data.mat');
rhos = squeeze(rhos.Data);
thetas = squeeze(thetas.Data);
counts = squeeze(counts.Data); 
w = length(counts);

t = Geometry.Transform([-0.5, -0.5, 0.5], eul2quat([deg2rad(45),deg2rad(12),0]));
camera = Camera.Camera(t, 240, 360);

figure;
title('Video Image');

for i = 1:w
    cla;
    camera.image.UpdateFieldLine(rhos(:,i), thetas(:,i), counts(i));    
    camera.Draw();
    xlim([-1, 5]);
    ylim([-1, 5]);
    view(0,90)
    pause(0.03);
end
