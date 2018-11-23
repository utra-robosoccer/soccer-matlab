classdef Animation
    %ANIMATION Animation is going from a pose to another pose
    
    properties
        statebegin          % State
        stateend            % State
        trajectory          % [N x duration/ts] double
        ts = 0.01           % Sample time
        duration            % Double
    end

    methods
        % Default constructor
        function obj = Animation(statebegin, stateend, ts, duration)
            obj.statebegin = statebegin;
            obj.stateend = stateend;
            obj.ts = ts;
            obj.duration = duration;
        end
     
        function tseries = GetTimeSeries(obj)
            tseries = timeseries(obj.trajectory, obj.GetTimeVector);
        end
        
        function tvector = GetTimeVector(obj)
            tvector = obj.ts:obj.ts:obj.duration;
        end
        
        function frameCount = GetFrameCount(obj)
            frameCount = obj.duration / obj.ts;
        end
    end
    
    methods(Static)
        % Creates an animation using the 2 states
        function obj = CreateAnimation(statebegin, stateend, ts, duration)
            obj = Animation.Animation(statebegin, stateend, ts, duration);
            
            % Create smooth path
            t = [0 obj.duration];

            % Create the spline
            trajpoints = [obj.statebegin.angles; obj.stateend.angles];
            obj.trajectory = spline(t, trajpoints', obj.GetTimeVector)';
        end
        
        % Creates an animation using keyframes
        % keyframes = [N x 18] frames for the robot
        % smoothframes (optional argument to smooth the trajectory by moving average filter)
        function obj = CreateAnimationKeyframes(keyframes, ts, duration, smoothframes)
            obj = Animation.Animation(Animation.State(keyframes(1,:)), Animation.State(keyframes(end,:)), ts, duration);

            if (nargin <= 3)
                smoothframes = 0.02;
            end
            
            % Create the spline
            tvector = obj.GetTimeVector;
            [frameCount,~] = size(keyframes);
            tframes = linspace(0, duration, frameCount); % # seconds to getup
            trajspline = spline(tframes, keyframes', tvector)';

            % Smooth the trajectory
            obj.trajectory = zeros(size(trajspline));
            for i = 1:20
                obj.trajectory(:,i) = smooth(trajspline(:,i), smoothframes);
            end
        end
        
        % Create a nodding trajectory based on a current state
        function obj = CreateAnimationHeadNodding(statecurrent, ts, duration)
            obj = Animation.Animation(statecurrent, statecurrent, ts, duration);
            framecount = obj.GetFrameCount;
            
            % Create only the motion for the head
            headmotion = zeros(1,framecount);
            for i = 1:framecount/2
               headmotion(i) = (framecount/4 - i) / framecount/4 * pi/4;
            end
            for i = 1:framecount/2
               headmotion(framecount/2 + i) = (i - framecount/4) / framecount/4 * pi/4;
            end
            
            % Fill in the rest of trajectory
            obj.trajectory = zeros(framecount,20);
            for i = 1:framecount
               obj.trajectory(i,:) = statecurrent.angles;
            end
            obj.trajectory(:,18) = headmotion;
        end
        
        function obj = CreateAnimationHeadShaking(statecurrent, ts, duration)
            obj = Animation.Animation(statecurrent, statecurrent, ts, duration);
            framecount = obj.GetFrameCount;
            
            % Create only the motion for the head
            headmotion = zeros(1,framecount);
            for i = 1:framecount/2
               headmotion(i) = (framecount/4 - i) / framecount/4 * pi/2;
            end
            for i = 1:framecount/2
               headmotion(framecount/2 + i) = (i - framecount/4) / framecount/4 * pi/2;
            end
            
            % Fill in the rest of trajectory
            obj.trajectory = zeros(framecount, 20);
            for i=1:framecount
               obj.trajectory(i,:) = statecurrent.angles;
            end
            obj.trajectory(:,17) = headmotion;
        end
    end
end

