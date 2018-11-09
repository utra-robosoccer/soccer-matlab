function segments = trimlines(rho, theta, counts, H, W)
% trimlines  Takes in a vector of lines defined by rho and theta and
% outputs a vector of segments, where the segments are segmented
% by the intersections of the lines, essentially there should be no
% crossings between lines after that. The lines must also be bounded the
% the edge of the screen (H,W = 240x320) window
%   
%   segments = trimelines(rho, theta)
%
% Example: rho = [50,50], theta = [0, 1.57], H = 100, W = 100
% 
% Output:
%   Seg1 = [(0, 50), (50, 50)]
% . Seg2 = [(50, 0), (50, 50)]
%

% Zero out invalid values
for i = 1:length(counts)
    for j = 1:3
        if (counts(i) < j)
            rhos(j,i) = 0;
            thetas(j,i) = 0;
        end
    end
end

% Define emtpy array of lines
lines = Geometry.Line2f.empty(counts,0);

% Create lines and normalize
for i = 1:length(counts)
    lines(i) = Line2f(rho(i), theta(i));
end

% Center lines at (W/2, 0)
for i = 1:length(counts)
    lines(i) = line(i).newOrigin(W/2,0);
end

% Sort in order of angle
[~, ind] = sort([lines.theta]);
lines = lines(ind);

% TODO Deal with parallel lines

% For the left and right most lines, find intersections with the border of 
% the camera screen, for the ones in between, find intersections among the
% lines themselves
points = [];
p_index = 1;
points(1) = pickLeftIntersection(lines(0).screenIntersection(H,W));
p_index = p_index + 1;
for i = 2:length(counts)
    intersection = Geometry.Line2f.intersection(lines(i),lines(i-1));
    if isOutOfPicture(intersect)
        points(p_index) = pickRightIntersection(line(i-1).screenIntersection(H,W));
        p_index = p_index + 1;
        points(p_index) = pickLeftIntersection(line(i).screenIntersection(H,W));
        p_index = p_index + 1;
    else
        points(p_index) = intersection;
        p_index = p_index + 1;
        points(p_index) = intersection;
        p_index = p_index + 1;
    end
    
end
% Return a list of segments
for i=1:2:length(points)
    segments((i+1)/2) = Geometry.Segment2f(points(i), points(i+1));
end

function intersect = pickLeftIntersection(points)
    p1 = points.p1;
    p2 = points.p2;
    if p1.x < p2.x
        intersect = p1;
    elseif p1.x > p2.x
        intersect = p2;
    elseif p1.y < p2.y
        intersect = p1;
    else
        intersect = p2;
    end
end

function intersect = pickRightIntersection(points)
    p1 = points.p1;
    p2 = points.p2;
    if p1.x > p2.x
        intersect = p1;
    elseif p1.x < p2.x
        intersect = p2;
    elseif p1.y < p2.y
        intersect = p1;
    else
        intersect = p2;
    end

end
function outOfPicture = isOutOfPicture(point, H, W)
    outOfPicture = point.x > W | point.y > H | point.x < 0 | point.y < 0;
end