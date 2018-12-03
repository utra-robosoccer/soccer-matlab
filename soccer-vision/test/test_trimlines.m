%%
clear; close all; clc;

line1 = Geometry.Line2f(50,0);
line2 = Geometry.Line2f(50,1.57);
lines = [line1, line2];
segments = trimlines(lines, 100, 100);

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

line1 = Geometry.Line2f(76,1.55);
line2 = Geometry.Line2f(87,-0.82);
lines = [line1, line2];
segments = trimlines(lines, 240, 360);

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

segments = trimlines(lines, 240, 360);

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

segments = {};

for i = 1:w
    lines = Geometry.Line2f.empty(counts(i),0);
    for j = 1:counts(i)
        lines(j) = Geometry.Line2f(rhos(j,i), thetas(j,i));
    end
    segments{i} = trimlines(lines, 240, 360);
end

figure;

for i = 1:w
    
    subplot(2,1,1);
    
    lines = Geometry.Line2f.empty(counts(i),0);
    hold on;
    for j = 1:counts(i)
        lines(j) = Geometry.Line2f(rhos(j,i), thetas(j,i));
        l2 = lines(j).newOrigin(-240,0);
        l2.Draw(240,360);
    end
    
% 
%     subplot(2,1,2);
%     hold on;
%     for k = 1:length(segments{i})
%         segments{i}{k}.Draw(240,360);
%     end
    pause(0.03);
    cla;
end

