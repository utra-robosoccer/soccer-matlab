classdef Camera
    %CAMERA 
    
    properties
        pose; % Geometry.Transform
        resolution_x = 360;
        resolution_y = 240;
        
        % Values for the C920 camera
        diagonal_fov = 1.36; % radians (field of view)
        focal_length = 3.67; % mm
    end
    
    methods
        function obj = Camera(pose, resolution_x, resolution_y)
            obj.pose = pose;
            obj.resolution_x = resolution_x;
            obj.resolution_y = resolution_y; 
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
        
        function Draw(obj)
            obj.pose.Draw;
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
        function [tx, ty] = ImageSensorLocation(obj, pixelx, pixely)
            deltay = (obj.resolution_y - pixely) - obj.resolution_y / 2;
            deltax = (pixelx) - obj.resolution_x / 2;
            
            ty = deltay * obj.PixelHeight;
            tx = deltax * obj.PixelWidth;
        end
    end
end

