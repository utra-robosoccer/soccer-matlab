length = 9000;
width = 6000;
goaldepth = 600;
goalwidth = 2600;
goalheight = 1800;
goalareaheight = 1000;
goalareawidth = 5000;
penaltymarkdistance = 2100;
centercirclediameter = 1500;
borderstripwidth = 700;

% Y is length, X is width

soccerfieldpoints = [ ...
    % 4 corners
    width/2, length/2;
    width/2, -length/2;
    -width/2, length/2;
    -width/2, -length/2;
    
    % Goal width
    goalwidth/2, length/2;
    -goalwidth/2, length/2;
    
    % Goal area rectangle
    goalareawidth/2, length/2;
    -goalareawidth/2, length/2;
    goalareawidth/2, length/2 - goaldepth;
    -goalareawidth/2, length/2 - goaldepth;
    
    % Goal width
    goalwidth/2, -length/2;
    -goalwidth/2, -length/2;
    
    % Goal area rectangle
    goalareawidth/2, -length/2;
    -goalareawidth/2, -length/2;
    goalareawidth/2, -length/2 + goaldepth;
    -goalareawidth/2, -length/2 + goaldepth;
    
    % Center Line
    width/2, 0;
    -width/2, 0;
];

% close all
% figure('rend','painters','pos',[10 10 width/10 length/10]);
% drawfield(0, soccerfieldpoints);
    