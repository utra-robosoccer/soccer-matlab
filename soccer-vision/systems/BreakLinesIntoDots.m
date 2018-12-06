classdef BreakLinesIntoDots < matlab.System

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

        function dots = stepImpl(obj, thetas, rhos, counts, transform)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            obj.camera.pose;
            obj.camera.image.UpdateFieldLine(rhos, thetas, counts);
            dots = obj.camera.GetDots;
        end
    end
end
