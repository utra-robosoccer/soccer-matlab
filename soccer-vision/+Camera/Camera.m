classdef Camera
    %CAMERA 
    
    properties
        % Geometry.Transform
        pose; 

        % Values for the C920 camera
        resolution_y = 240;
        resolution_x = 360;
        diagonal_fov = 1.36; % radians (field of view)
        focal_length = 3.67; % mm
        
        % Camera Image (type Camera Image)
        image
    end
    
    methods
        function obj = Camera(pose, resolution_y, resolution_x)
            obj.pose = pose;
            obj.resolution_x = resolution_x;
            obj.resolution_y = resolution_y; 
            
            obj.image = Camera.Image(resolution_y, resolution_x);
        end
        
        function DrawPixelRayTrace(obj, pixelx, pixely)
            point3f = obj.FindFloorCoordinate(pixelx, pixely);
            seg3f = Geometry.Segment3f(obj.pose.GetPoint3f, point3f);
            seg3f.Draw;
        end
        
        function point3f = FindFloorCoordinate(obj, pixelx, pixely)
            [tx, ty] = obj.ImageSensorLocation(pixelx, pixely);
            
            % x is direction forward, backward
            % y is direction left right
            % z is direction up down
            pixelrelLocation3d = Geometry.Transform([obj.focal_length / 1000, tx / 1000, ty / 1000]);
            
            % Coordinate of pixel in real space
            pixelLocation3d = pixelrelLocation3d.ApplyTransformation(obj.pose);
            
            % Raytrace that pixel onto the floor
            ratio = (pixelLocation3d.Z - obj.pose.Z) / obj.pose.Z;
            xdelta = (pixelLocation3d.X - obj.pose.X) / ratio;
            ydelta = (pixelLocation3d.Y - obj.pose.Y) / ratio;
            
            point3f = Geometry.Point3f(obj.pose.X - xdelta, obj.pose.Y - ydelta, 0);
        end
        
        function dots = GetDots(obj)
            dots = {};
            for i = 1:length(obj.image.segments)
                p13d = obj.FindFloorCoordinate(obj.image.segments{i}.p1.x, obj.image.segments{i}.p1.y);
                p23d = obj.FindFloorCoordinate(obj.image.segments{i}.p2.x, obj.image.segments{i}.p2.y);
                seg = Geometry.Segment3f(p13d, p23d);
                dots = [dots seg.ConvertToDots(0.1)];
            end
        end
        
        function Draw(obj)
            obj.pose.Draw;
            
            hold on;
            
            % Plane
            [X,Y] = meshgrid(-10:10,-10:10);
            Z=zeros(length(Y),length(X));
            surf(X,Y,Z,'linestyle','none','facecolor',[.7 .95 .7]);
            
            % Determine if angle is great enough to draw entire frame
            drawentireframe = true;
            drawhalfframe = true;
            if (obj.pose.Pitch < obj.VerticalFOV)
                drawentireframe = false;
            end
            if (obj.pose.Pitch < obj.VerticalFOV / 2)
                drawhalfframe = false;
            end
            
            % Camera Ray Trace Edges
            obj.DrawPixelRayTrace(0, 0);
            obj.DrawPixelRayTrace(obj.resolution_x, 0);
            
            if (drawentireframe)
                obj.DrawPixelRayTrace(obj.resolution_x, obj.resolution_y);
                obj.DrawPixelRayTrace(0, obj.resolution_y);
            end
            
            if (drawhalfframe)
                obj.DrawPixelRayTrace(obj.resolution_x/2, obj.resolution_y/2);
            end
            
            % Floor square
            p1 = obj.FindFloorCoordinate(0, 0);
            p2 = obj.FindFloorCoordinate(obj.resolution_x, 0);
            p3 = obj.FindFloorCoordinate(obj.resolution_x, obj.resolution_y);
            p4 = obj.FindFloorCoordinate(0, obj.resolution_y);
            
            p5 = obj.FindFloorCoordinate(0, obj.resolution_y / 2);
            p6 = obj.FindFloorCoordinate(obj.resolution_x, obj.resolution_y / 2);
            
            
            seg1 = Geometry.Segment3f(p1, p2);
            seg2 = Geometry.Segment3f(p2, p3);
            seg3 = Geometry.Segment3f(p3, p4);
            seg4 = Geometry.Segment3f(p1, p4);
            
            seg5 = Geometry.Segment3f(p1, p5);
            seg6 = Geometry.Segment3f(p2, p6);
            
            seg1.Draw();
            
            if(drawentireframe)
                seg2.Draw();
                seg3.Draw();
                seg4.Draw();
            elseif (drawhalfframe)
                seg5.Draw();
                seg6.Draw();
            end
            
            % Segments
            dots = obj.GetDots;
            for i = 1:length(dots)
                dots{i}.Draw;
            end
        end
    end
    
    methods(Access = private)
        function fov = VerticalFOV(obj)
            fov = obj.resolution_y / sqrt(obj.resolution_x^2 + obj.resolution_y^2);
        end
        function fov = HorizontalFOV(obj)
            fov = obj.resolution_x / sqrt(obj.resolution_x^2 + obj.resolution_y^2);
        end
        function h = ImageSensorHeight(obj) % mm
            h = tan(obj.VerticalFOV / 2) * 2 * obj.focal_length;
        end
        function w = ImageSensorWidth(obj) % mm
            w = tan(obj.HorizontalFOV / 2) * 2 * obj.focal_length;
        end
        function h = PixelHeight(obj) % mm
            h = obj.ImageSensorHeight / obj.resolution_y;
        end
        function w = PixelWidth(obj) % mm
            w = obj.ImageSensorWidth / obj.resolution_x;
        end
        
        function [tx, ty] = ImageSensorLocation(obj, xpos, ypos)
            deltay = ypos - obj.resolution_y / 2;
            deltax = xpos - obj.resolution_x / 2;
            
            ty = deltay * obj.PixelHeight;
            tx = deltax * obj.PixelWidth;
        end
        
        function [tx, ty] = ImageSensorLocationPixel(obj, pixelx, pixely)
            deltay = (obj.resolution_y - pixely) - obj.resolution_y / 2;
            deltax = (pixelx) - obj.resolution_x / 2;
            
            ty = deltay * obj.PixelHeight;
            tx = deltax * obj.PixelWidth;
        end
    end
end

