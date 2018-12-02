


rhos = [50,50];
thetas = [0, 1.57];
count = 2;
segments = trimlines(rhos, thetas, count, 100, 100);

%%
load('soccer-vision/data/linesData.mat');
rhos = squeeze(rhoS.Data);
thetas = squeeze(thetaS.Data);
counts = squeeze(countS.Data);
segments_array = {};
for i=1:length(rhos)
    segments_array{i} = trimlines(rhos(:, i), thetas(:, i), counts(i), 240, 360);
end
% segments = trimlines(rhos, thetas, counts, 240, 360);
