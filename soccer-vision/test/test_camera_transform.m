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

%% Break all the lines into points and plot them

% TODO