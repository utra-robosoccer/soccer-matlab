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
        function Draw(obj, height, width)
            plot([obj.p1.x obj.p2.x], [obj.p1.y obj.p2.y])
            if (nargin == 3)
                ylim([-10,height+10]);
                xlim([-10,width+10]);
            end
        end
        
        % Point2f is the starting point, angles is a array of angles
        % shoots at. Returns a single intercept
        function intercepts = FindIntercept(obj, origin, angles)
            intercepts = [];
            ang1 = atan2(obj.p1.y - origin.y, obj.p1.x - origin.x);
            ang2 = atan2(obj.p2.y - origin.y, obj.p2.x - origin.x);
            
            if (ang1 > ang2)
                angmax = ang1;
                angmin = ang2;
                pangmin = obj.p2;
            else
                angmax = ang2;
                angmin = ang1;
                pangmin = obj.p1;
            end
            
            theta1 = angmin;
            theta3 = obj.Angle;
            langlemin = Geometry.Point2f.Distance(pangmin, origin);
            
            for angle = angles
                if (angle > angmax)
                    continue
                elseif (angle < angmin)
                    continue
                end
                
                theta2 = angle - angmin;
                
                del_l = sin(theta2) / sin(pi - (theta1 - theta3) - theta2) * langlemin;
                
                intercept = Geometry.Point2f(pangmin.x - del_l * cos(theta3), pangmin.y - del_l * sin(theta3));
                intercepts = [intercepts intercept];
            end
        end
        
        function k = Slope(obj)
            k = (obj.p2.y - obj.p1.y) / (obj.p2.x - obj.p1.x);
        end
        
        function b = YIntercept(obj)
            b = obj.p1.y - obj.p1.x * obj.Slope;
        end
        
        function angle = Angle(obj)
            if (obj.p2.x > obj.p1.x)
                angle = atan2(obj.p2.y - obj.p1.y, obj.p2.x - obj.p1.x);
            else
                angle = atan2(obj.p1.y - obj.p2.y, obj.p1.x - obj.p2.x);
            end
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
            
            intersect = Geometry.Point2f(x, y);
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
            yintersect = m1 * xintersect + b1;
            
            intersect = Geometry.Point2f(xintersect,yintersect);
        end
    end
end

