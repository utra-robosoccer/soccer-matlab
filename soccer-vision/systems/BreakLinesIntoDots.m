classdef BreakLinesIntoDots < matlab.System & matlab.system.mixin.Propagates

    % Public, tunable properties
    properties
        width = 360;
        height = 240;
        init_pitch = 12;
        init_height = 0.5;
    end

    % Pre-computed constants
    properties(Access = private)
        camera
        seq = 0
    end

    methods(Access = protected)
        function setupImpl(obj)
            t = Geometry.Transform([0.0, 0.0, obj.init_height], eul2quat([deg2rad(0),deg2rad(obj.init_pitch),0]));
            obj.camera = Camera.Camera(t, obj.height, obj.width);
        end

        function posearray = stepImpl(obj, thetas, rhos, counts, camerapose, posearray)
            % Update the position of the camera
            obj.camera.pose.position = [camerapose.Pose.Position.X, camerapose.Pose.Position.Y, camerapose.Pose.Position.Z];
            obj.camera.pose.orientation = [camerapose.Pose.Orientation.W, camerapose.Pose.Orientation.X, camerapose.Pose.Orientation.Y, camerapose.Pose.Orientation.Z];

            % Update the field lines and calculate positions
            obj.camera.image.UpdateFieldLine(rhos, thetas, counts);
            dots = obj.camera.GetDots;
            
            cla;
            obj.camera.Draw();
            xlim([-1, 2]);
            ylim([-1, 2]);
            view(0,90)
            
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
            posearray.Poses_SL_Info.CurrentLength = uint32(length(dots));
            posearray.Poses_SL_Info.ReceivedLength = uint32(length(dots));
            
            posearray.Header.Seq = uint32(obj.seq);
            frame_name = 'base_footprint';
            posearray.Header.FrameId(1:length(frame_name)) = uint32(frame_name);
            posearray.Header.FrameId_SL_Info.CurrentLength = uint32(length(frame_name));
            posearray.Header.FrameId_SL_Info.ReceivedLength = uint32(length(frame_name));
            rt = rostime("now","system");
            posearray.Header.Stamp.Sec = rt.Sec;
            posearray.Header.Stamp.Nsec = rt.Nsec;
            obj.seq = obj.seq + 1;
        end
        
        function [c1] = isOutputFixedSizeImpl(~)
            c1 = false;
        end
        function [sz_1] = getOutputSizeImpl(~)
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
