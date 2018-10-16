load('soccer-vision/data/linesData.mat');
rhos = squeeze(rhoS.Data);
thetas = squeeze(rhoS.Data);

segments = trimlines(rhos, thetas);