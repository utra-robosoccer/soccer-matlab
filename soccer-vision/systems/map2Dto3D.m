classdef map2Dto3D < matlab.System & matlab.system.mixin.SampleTime
    % Converts a 2d to 3d point on the field
    %

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(~)
            % Perform one-time calculations, such as computing constants
        end

        function lines3D = stepImpl(~, lines, img, robotHeight, d, robotAngle, cameraAngle, focalLength)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            lines3D = lines2Dto3D(double(lines), img, robotHeight, d, robotAngle, cameraAngle, focalLength);
        end

        function resetImpl(~)
            % Initialize / reset discrete-state properties
        end
    end
end
