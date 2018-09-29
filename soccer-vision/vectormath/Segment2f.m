classdef Segment2f < handle
    %LINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        p1
        p2
    end
    
    methods
        function obj = Segment2f(p1,p2)
            %LINE Construct an instance of this class
            %   Detailed explanation goes here
            obj.p1 = p1;
            obj.p2 = p2;
        end
        function valid = isValid(obj)
            valid = ~((obj.p1.x == 0 && obj.p1.y == 0) || (obj.p2.x == 0 && obj.p2.y == 0));
        end
        function s = slope(obj)
            s = (obj.p2.y - obj.p1.y) / (obj.p2.x - obj.p1.x);
        end
        function b = intersecty(obj)
            b = obj.p1.y - obj.slope * obj.p1.x;
        end
    end
    
    methods(Static)
        function intersect = intersection(obj1, obj2)
            %METHOD1 Finds the screen intersection between 2 points
            
            slope1 = obj1.slope;
            slope2 = obj2.slope;
            intersecty1 = obj1.intersecty;
            intersecty2 = obj2.intersecty;
            
            x = (intersecty2 - intersecty1) / (slope1 - slope2);
            y = slope1 * x + intersecty1;
            
            intersect = Point2f(x, y);
        end
        function intersect = intersection2(obj1, obj2)
            %METHOD1 Finds the screen intersection between 2 points
            
            x1 = obj1.p1.x;
            x2 = obj1.p2.x;
            x3 = obj2.p1.x;
            x4 = obj2.p2.x;
            
            y1 = obj1.p1.y;
            y2 = obj1.p2.y;
            y3 = obj2.p1.y;
            y4 = obj2.p2.y;
            
            line1 = [x1, y1; x2, y2];
            line2 = [x3, y3; x4, y4];
            
            m1 = (line1(2,2) - line1(1,2))/(line1(2,1) - line1(1,1));
            m2 = (line2(2,2) - line2(1,2))/(line2(2,1) - line2(1,1));

            b1 = line1(1,2) - m1*line1(1,1);
            b2 = line2(1,2) - m2*line2(1,1);

            xintersect = (b2-b1)/(m1-m2);
            yintersect = m1*xintersect + b1;
            
            intersect = Point2f(xintersect,yintersect);
        end
    end
end

