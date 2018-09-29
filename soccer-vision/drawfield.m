function drawfield(lines, points)
    [h, ~] = size(lines);
    
    if (h == 9)
        for i = 1:h
            plot(lines(i,[1,3]), lines(i,[2,4]));
            hold on;
        end
    end

    if(nargin == 2)
        [h, ~] = size(points);

        for i = 1:h
            if (points(i,2) <= 0)
                continue                
            end

            plot(points(i,1), points(i,2), 'o');
            hold on;
        end
    end
    
    ylim([-9000,9000]); % 5 meters
    xlim([-5000 5000]);
    grid on;
    hold off;
end