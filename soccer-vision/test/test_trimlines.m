%%
clear; close all; clc;

cam = Camera.Image(100,100);
line1 = Geometry.Line2f(50,0);
line2 = Geometry.Line2f(50,1.57);
lines = [line1, line2];
segments = cam.TrimLines(lines);

figure;
subplot(2,1,1);
hold on;
for i = 1:length(lines)
    lines(i).Draw(100,100);
end

subplot(2,1,2);
hold on;
for i = 1:length(segments)
    segments{i}.Draw(100,100);
end

%%
clear; close all; clc;

cam = Camera.Image(240,360);
line1 = Geometry.Line2f(76,1.55);
line2 = Geometry.Line2f(87,-0.82);
lines = [line1, line2];
segments = cam.TrimLines(lines);

figure;
subplot(2,1,1);
hold on;
for i = 1:length(lines)
    lines(i).Draw(240,360);
end

subplot(2,1,2);
hold on;
for i = 1:length(segments)
    segments{i}.Draw(260,360);
end

%%
line1 = Geometry.Line2f(-96,-1.5);
line2 = Geometry.Line2f(107,-0.78);
line3 = Geometry.Line2f(124,0.78);
lines = [line1, line2, line3];

cam = Camera.Image(240,360);
segments = cam.TrimLines(lines);

figure;
subplot(2,1,1);
hold on;
for i = 1:length(lines)
    lines(i).Draw(240,360);
end

subplot(2,1,2);
hold on;
for i = 1:length(segments)
    segments{i}.Draw(240,360);
end


%%
clear; close all; clc;

load('soccer-vision/data/lines_data.mat');
rhos = squeeze(rhos.Data);
thetas = squeeze(thetas.Data);
counts = squeeze(counts.Data); 

[l,w] = size(rhos);

cam = Camera.Image(240,360);

figure;
for i = 1:w
    
    subplot(2,1,1);
    title('Lines Before');
    cla;
    lines = Geometry.Line2f.empty(counts(i),0);
    hold on;
    
    for j = 1:counts(i)
        lines(j) = Geometry.Line2f.ImgConvention(rhos(j,i), thetas(j,i), 240);
        lines(j).Draw(240,360);
    end
    grid minor;
    
    subplot(2,1,2);
    title('Lines After');
    cla;
    hold on;
    cam.UpdateFieldLine(rhos(:,i), thetas(:,i), counts(i));
    cam.Draw();
    grid minor;
    
    pause(0.03);
end

