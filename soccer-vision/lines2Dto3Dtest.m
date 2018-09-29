% Camera size is 540 x 960. Draw square
close all;

cx = 960 / 2;
cy = 540 / 2;
width = 100;
lines1 = [
    cx + 480, cy - 270, cx + 480, cy + 270;
    cx + 480, cy - 270, cx - 480, cy - 270;
    cx - 480, cy - 270, cx - 480, cy + 270;
    cx - 480, cy + 270, cx + 480, cy + 270;
    
    cx + width, cy + width, cx + width, cy - width;
    cx + width, cy - width, cx - width, cy - width;
    cx - width, cy - width, cx - width, cy + width;
    cx - width, cy + width, cx + width, cy + width;
    cx, cy - width, cx, cy + width;
    cx - width, cy, cx + width, cy;
    cx + width/2, cy + width, cx + width/2, cy - width;
    cx - width/2, cy + width, cx - width/2, cy - width;
    cx - width, cy - width/2, cx + width, cy - width/2;
    cx - width, cy + width/2, cx + width, cy + width/2;
    ];

lines2 = [681,1,691,540;189,1,218,540;1,1,1,2;1,1,1,2;259,1,960,492;1,1,1,2;612,1,1,478;1,329,960,312;0,0,0,0];
lines = [lines2];
% drawfield(lines)


[l, w] = size(lines);

img = zeros(540, 960);
robotHeight = 500; % Half a meter tall
d = -5;
robotAngle = 0;
cameraAngle = pi/16; % Looking 10 degrees down
focalLength = 630; % Needs to be calibrated

lines3D = lines2Dto3D(lines, img, robotHeight, d, robotAngle, cameraAngle, focalLength);

lines3Dplane = lines3D(:, [1,2,4,5]);
drawfield(lines3Dplane)
