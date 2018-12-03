classdef BreakLinesIntoDots < matlab.System

    % Public, tunable properties
    properties

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function dots = stepImpl(obj, rhos, thetas, count)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            
            % Call function here
            H = 240;
            W = 360;
            dots = trimlines(rhos, thetas, count, H, W)
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
