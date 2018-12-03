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

%% Create the camera
t = Geometry.Transform([0.5, 0.5, 1.0], eul2quat([0,deg2rad(30),deg2rad(30)]));
camera = Camera.Camera(t, 240, 360);
camera.Draw();

