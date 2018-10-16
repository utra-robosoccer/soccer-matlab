

currentPose = ...
    [1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 0 1];

close all
figure
for i = 1:300
    pause(0.1);
    fieldSeen = fieldpoints.data(:,:,i);
    lineSeen = linepoints.data(:,:,i);
    
%     drawfield(lineSeen(:, [1,2,4,5]), fieldSeen);
    
    [currentPose] = matchfield(fieldSeen, currentPose);
    drawnow;
end