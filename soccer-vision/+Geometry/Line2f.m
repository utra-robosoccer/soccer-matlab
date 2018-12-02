classdef Line2f < handle
    %LINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rho
        theta
    end
    
    methods
        function obj = Line2f(rho, theta)
            %LINE Construct an instance of this class
            %   Detailed explanation goes here
            obj.rho = rho;
            obj.theta = theta;
            normalize(obj);
            return;
        end
        function normalize(obj)
           if(obj.rho < 0)
              obj.rho = -obj.rho;
              if (obj.theta < pi/2)
                  obj.theta = obj.theta + pi;
              else
                  obj.theta = obj.theta - pi;
              end
           end
        end
        function point = center(obj)
            point = Geometry.Point2f(obj.rho * cos(obj.theta), obj.rho * sin(obj.theta));
        end
        function v = normalUnitVector(obj)
            v = Geometry.Vec2f(cos(obj.theta), sin(obj.theta));
        end
        function line2f = newOrigin(obj, x, y)
            v = Geometry.Vec2f(x, y);
            % v2 = Geometry.Vec2f(obj.center().x, obj.center().y);
            vu = obj.normalUnitVector();
            % proj = v2.Projection(v);
            proj = vu.Projection(v);
            
            line2f = Geometry.Line2f(obj.rho - proj, obj.theta);            
        end
        function segment = screenIntersection(obj, height, width)
            obj.normalize();
            
            w = width;
            h = height;
            
            bottomLine = Geometry.Line2f(0, pi/2);
            leftLine = Geometry.Line2f(0, 0);
            rightLine = Geometry.Line2f(w, 0);
            topLine = Geometry.Line2f(h, pi/2);
            
            diagtheta = atan2(h,w);
            diagrho = sqrt(h^2 + w^2);
            
            % No line if it crosses the two bounds
            if (obj.theta > pi/2 && obj.rho > h * cos(obj.theta - pi/2) || ...
                obj.theta < 0 && obj.rho > w * cos(obj.theta))
                r_int = Geometry.Point2f(0,0);
                l_int = Geometry.Point2f(0,0);
                segment = Geometry.Segment2f(r_int, l_int);
                return
            end
                
            % Right intersection
            if (obj.rho < w * cos(obj.theta))
                r_int = Geometry.Line2f.intersection(obj, bottomLine);
            elseif (obj.rho > diagrho * cos(obj.theta - diagtheta))
                r_int = Geometry.Line2f.intersection(obj, topLine);
            else
                r_int = Geometry.Line2f.intersection(obj, rightLine);
            end
            
            % Left intersection
            if (obj.rho < h * cos(pi/2 - obj.theta))
                l_int = Geometry.Line2f.intersection(obj, leftLine);
            elseif (obj.rho < diagrho * cos((pi/2 - obj.theta) - (pi/2 - diagtheta)))
                l_int = Geometry.Line2f.intersection(obj, topLine);
            else
                l_int = Geometry.Line2f.intersection(obj, rightLine);
            end
            segment = Geometry.Segment2f(r_int, l_int);
        end
        
        function draw(obj, height, width)
            seg = obj.screenIntersection(height, width);
            seg.draw();
        end
    end
    
    methods(Static)
        function intersect = intersection(l1, l2)
            %METHOD1 Finds the screen intersection between 2 points
            rho1 = l1.rho;
            theta1 = l1.theta;
            rho2 = l2.rho;
            theta2 = l2.theta;
            
            A = [cos(theta1), sin(theta1);
                cos(theta2), sin(theta2)];
            
            b = [rho1; rho2];
            
            r = A \ b;
            
            % Create the intersection
            intersect = Geometry.Point2f(r(1), r(2));
        end
    end
end

