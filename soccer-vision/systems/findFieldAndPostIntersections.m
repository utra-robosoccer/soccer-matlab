classdef findFieldAndPostIntersections < matlab.System
    % Find Field and Post Intersection
    % Numbering order of the lines
    % 1. Enemy Left post
    % 2. Enemy Right post
    % 3. Friendly Left Post
    % 4. Fieldly Right Post
    % 5. Enemy Back Line
    % 6. Left Field line
    % 7. Right Field line
    % 8. Frieldly Back line
    % 9. Center Line

    % Numbering order of the points (centers last)
    %  *----*----*----*
    %  |    |____|    |
    %  |              |
    %  *--------------*
    %  |     ____     |
    %  |    |    |    |
    %  *----*----*----*
    
    % Public, tunable properties
    properties

    end

    properties(DiscreteState)
        
    end

    % Pre-computed constants
    properties(Access = private)
        intersect
        lines
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.intersect = cell(10,1);
            obj.intersect{1} = Point2f(0,0);
            obj.intersect{2} = Point2f(0,0);
            obj.intersect{3} = Point2f(0,0);
            obj.intersect{4} = Point2f(0,0);
            obj.intersect{5} = Point2f(0,0);
            obj.intersect{6} = Point2f(0,0);
            obj.intersect{7} = Point2f(0,0);
            obj.intersect{8} = Point2f(0,0);
            obj.intersect{9} = Point2f(0,0);
            obj.intersect{10} = Point2f(0,0);
            
            obj.lines = cell(9,1);
            obj.lines{1} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{2} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{3} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{4} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{5} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{6} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{7} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{8} = Segment2f(Point2f(0,0), Point2f(0,0));
            obj.lines{9} = Segment2f(Point2f(0,0), Point2f(0,0));
        end

        function [lineArray, pointArray] = stepImpl(obj,lineArray)
            
            pointArray = zeros(10, 2);
            
            [l, w] = size(lineArray);
            if l ~= 9 || w ~= 6
                return;
            end
            
            for i = 1:9
                p1 = Point2f(lineArray(i,1), lineArray(i,2));
                p2 = Point2f(lineArray(i,4), lineArray(i,5));
                obj.lines{i} = Segment2f(p1, p2);
            end
            
            for i = 1:10
                obj.intersect{i}.x = 0;
                obj.intersect{i}.y = 0;
            end
            
            z = 1;
            % Field and Net intersection
%             for i = 1:4
%                 for j = 5:9
%                     if (obj.lines{i}.isValid && obj.lines{j}.isValid && z <= 10)
%                         obj.intersect{z} = Segment2f.intersection(obj.lines{i}, obj.lines{j});
%                         z = z + 1;
%                     end
%                 end
%             end
            
            % Field and Field intersection
            for i = 5:9
                for j = 5:9
                    if (i <= j)
                        continue
                    end
                    if (obj.lines{i}.isValid && obj.lines{j}.isValid && z <= 10)
                        inter = Segment2f.intersection2(obj.lines{i}, obj.lines{j});
                        if inter.y > 0 && inter.y < 9000 && inter.x < 6000 && inter.x > -6000
                            obj.intersect{z} = inter;
                            z = z + 1;
                        end
                    end
                end
            end
            
            for i = 1:10
               pointArray(i,1) = obj.intersect{i}.x;
               pointArray(i,2) = obj.intersect{i}.y;
            end
        end

        function resetImpl(~)
            % Initialize / reset discrete-state properties
        end
    end
end
