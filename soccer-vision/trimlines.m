function segments = trimlines(rho, theta, counts, H, W)
% time_lines  Takes in a vector of lines defined by rho and theta and
% outputs a vector of vector of segments, where the segments are segmented
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

% Create lines and normalize
for i = 1:length(counts)
    line{i} = Line2f(rho(i), theta(i));
end



    
end