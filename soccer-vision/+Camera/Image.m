classdef Image < handle
    
    properties
        height = 240;   % Y
        width = 360;    % X
        
        segments;
    end
    
    methods
        function obj = Image(height,width)
            obj.height = height;
            obj.width = width;
        end
        
        function UpdateFieldLine(obj, rhos, thetas, count)
            lines = Geometry.Line2f.empty(count,0);
            obj.segments = Geometry.Line2f.empty(count,0);
            for i = 1:count
                lines(i) = Geometry.Line2f.ImgConvention(rhos(i), thetas(i), obj.height);
            end
            obj.segments = obj.TrimLines(lines);
        end
        
        function Draw(obj)
            hold on;
            for i = 1:length(obj.segments)
                obj.segments{i}.Draw(obj.height, obj.width);
            end
        end
        
        function segments = TrimLines(obj, lines)
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
            %   Seg2 = [(50, 0), (50, 50)]
            
            counts = length(lines);
            
            % Center lines at (W/2, 0)
            for i = 1:counts
                lines(i) = lines(i).newOrigin(obj.width/2,0);
            end

            % Sort in order of angle
            [~, ind] = sort([lines.theta]);
            lines = lines(ind);

            % Revert back the lines after sorting the angles
            % Center lines at (-W/2, 0)
            for i = 1:counts
                lines(i) = lines(i).newOrigin(-obj.width/2,0);
                lines(i).normalize();
            end

            % TODO Deal with parallel lines

            % For the left and right most lines, find intersections with the border of 
            % the camera screen, for the ones in between, find intersections among the
            % lines themselves
            points = {};
            p_index = 1;
            points{1} = obj.pickLowerAngleIntersection(lines(1).screenIntersection(obj.height,obj.width), obj.width/2, 0);
            p_index = p_index + 1;

            % pickLowerAngleIntersection(points, orig_x, orig_y)

            % last line with screen
            % for i = 2:(counts)
            %     intersection = Geometry.Line2f.intersection(lines(i),lines(i-1));
            %     if isOutOfPicture(intersection, H, W)
            %         points{p_index} = pickRightIntersection(line(i-1).screenIntersection(H,W));
            %         p_index = p_index + 1;
            %         points{p_index} = pickLeftIntersection(line(i).screenIntersection(H,W));
            %         p_index = p_index + 1;
            %     else
            %         points{p_index} = intersection;
            %         p_index = p_index + 1;
            %         points{p_index} = intersection;
            %         p_index = p_index + 1;
            %     end
            %     
            % end

            for i = 2:(counts)
                intersection = Geometry.Line2f.intersection(lines(i),lines(i-1));
                if obj.isOutOfPicture(intersection, obj.height, obj.width)
                    points{p_index} = obj.pickLowerAngleIntersection(lines(i-1).screenIntersection(obj.height, obj.width), obj.width/2, 0);
                    p_index = p_index + 1;
                    points{p_index} = obj.pickLowerAngleIntersection(lines(i).screenIntersection(obj.height, obj.width), obj.width/2, 0);
                    p_index = p_index + 1;
                else
                    points{p_index} = intersection;
                    p_index = p_index + 1;
                    % points{p_index} = intersection;
                    % p_index = p_index + 1;
                end
            end


            % points{p_index} = pickRightIntersection(lines(end).screenIntersection(H,W));
            points{p_index} = obj.pickLeftIntersection(lines(end).screenIntersection(obj.height, obj.width));
            % points{p_index} = pickLowerAngleIntersection(lines(end).screenIntersection(H,W), W/2, 0);

            % % Return a list of segments
            % for i=1:2:length(points)
            %     segments{(i+1)/2} = Geometry.Segment2f(points{i}, points{i+1});
            % end

            for i=2:length(points)
                segments{i - 1} = Geometry.Segment2f(points{i - 1}, points{i});
            end


        end
    end
    
    methods(Access = private)
        function intersect = pickLeftIntersection(~, points)
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

        function intersect = pickRightIntersection(~, points)
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

        function angle = angleWRTxaxis(~, p, orig_x, orig_y)
            angle = atan((p.y - orig_y) / (p.x - orig_x));
            if (p.x - orig_x) < 0
                if angle > 0
                    angle = angle - pi;
                else
                    angle = angle + pi;
                end
            end
        end

        function intersect = pickLowerAngleIntersection(obj, points, orig_x, orig_y)
            p1 = points.p1;
            p2 = points.p2; 
            angle1 = obj.angleWRTxaxis(p1, orig_x, orig_y);
            angle2 = obj.angleWRTxaxis(p2, orig_x, orig_y);
            if abs(angle1 - angle2) > pi
                if angle1 > angle2
                    intersect = p1;
                else
                    intersect = p2;
                end
            else
                if angle1 > angle2
                    intersect = p2;
                else
                    intersect = p1;
                end
            end
        end

        function outOfPicture = isOutOfPicture(~, point, H, W)
            outOfPicture = point.x > W | point.y > H | point.x < 0 | point.y < 0;
        end
    end
end

