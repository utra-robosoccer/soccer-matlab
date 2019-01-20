classdef BreakLinesIntoDots < matlab.System & matlab.system.mixin.Propagates

    % Public, tunable properties
    properties
        width = 360;
        height = 240;
        init_pitch = 30;
        init_height = 0.5;
    end

    % Pre-computed constants
    properties(Access = private)
        camera
    end

    methods(Access = protected)
        function setupImpl(obj)
            t = Geometry.Transform([0.0, 0.0, 0.5], eul2quat([deg2rad(0),deg2rad(obj.init_pitch),0]));
            obj.camera = Camera.Camera(t, obj.width, obj.height);
        end

        function posearray = stepImpl(obj, thetas, rhos, counts, camerapose, posearray)
            % Update the position of the camera
            obj.camera.pose.position = [camerapose.Pose.Position.X, camerapose.Pose.Position.Y, camerapose.Pose.Position.Z];
            obj.camera.pose.orientation = [camerapose.Pose.Orientation.W, camerapose.Pose.Orientation.X, camerapose.Pose.Orientation.Y, camerapose.Pose.Orientation.Z];

            % Update the field lines and calculate positions
            obj.camera.image.UpdateFieldLine(rhos, thetas, counts);
            dots = obj.camera.GetDots;
            
            % Output
            for i = 1:length(dots)
                posearray.Poses(i).Position.X = dots{i}.x;
                posearray.Poses(i).Position.Y = dots{i}.y;
                posearray.Poses(i).Position.Z = dots{i}.z;
                posearray.Poses(i).Orientation.X = 0;
                posearray.Poses(i).Orientation.Y = 0;
                posearray.Poses(i).Orientation.Z = 0;
                posearray.Poses(i).Orientation.W = 1;
            end
        end
        
        function [c1] = isOutputFixedSizeImpl(~)
            c1 = false;
        end
        function [sz_1] = getOutputSizeImpl(obj)
            sz_1 = 1;
        end 
        function [out1] = getOutputDataTypeImpl(~)
            out1 = "SL_Bus_soccer_vision_geometry_msgs_PoseArray";
        end
        function [c1] = isOutputComplexImpl(~)
            c1 = false;
        end
    end
end
