classdef Animation
    %ANIMATION Animation is going from a pose to another pose
    
    properties
        statebegin          % State
        stateend            % State
        trajectory          % [N x duration/ts] double
        ts = 0.01           % Sample time
        duration            % Double
        calibration
    end

    methods
        % Default constructor
        function obj = Animation(statebegin, stateend, ts, duration)
            obj.statebegin = statebegin;
            obj.stateend = stateend;
            obj.ts = ts;
            obj.duration = duration;
            obj.calibration = zeros(1,20);
        end
     
        function tseries = TimeSeries(obj)
            tseries = timeseries(obj.trajectory, obj.TimeVector);
        end
        
        function tvector = TimeVector(obj)
            tvector = obj.ts:obj.ts:obj.duration;
        end
        
        function frameCount = FrameCount(obj)
            frameCount = obj.duration / obj.ts;
        end
        
        function Plot(obj)
            plot(obj.TimeVector, obj.trajectory);
            title('Trajectory');
            xlabel('Seconds');
            ylabel('Angles');
            legend('Torso Left Hip Side', ...,
                'Left Hip Side Front', ...,
                'Left Hip Front Thigh', ...,
                'Left Thigh Calve', ...,
                'Left Calve Ankle', ...,
                'Left Ankle Foot', ...,
                'Torso Right Hip Side', ...,
                'Right Hip Side Front', ...,
                'Right Hip Front Thigh', ...,
                'Right Thigh Calve', ...,
                'Right Calve Ankle', ...,
                'Right Ankle Foot')
            grid minor;
        end
        
        function calibratedangles = CalibratedAngles(obj)
            [l,w] = size(obj.trajectory);
            calibratedangles = zeros(l,w);
            for i = 1:l
                calibratedangles(i,1:w) = obj.trajectory(i, 1:w) + obj.calibration(1:w);
            end
        end
        
        function angles = UrdfConventionAngles(obj)
            angles = obj.CalibratedAngles;
            
            angles(:,1) = -angles(:,1);
            angles(:,6) = -angles(:,6);
        end
        
        function Publish(obj, step)
            if (nargin == 1)
                step = 0;
            end
            
            % Connects to the simulation (gazebo)
            connectrobot

            jointangles = obj.UrdfConventionAngles;

            robotgoalpub = rospublisher('/robotGoal','soccer_msgs/RobotGoal');

            msg = rosmessage(robotgoalpub);

            for i = 1:length(jointangles)
                msg.Trajectories(1:18) = jointangles(i,1:18);
                robotgoalpub.send(msg)
                
                if (step)
                    pause;
                else
                    pause(obj.ts);
                end
            end
        end
    end
    
    methods(Static)
        function obj = CreateAnimation(angles, ts)
            [l,~] = size(angles);
            duration = l*ts;
            obj = Animation.Animation(Animation.State(angles(1,:)), Animation.State(angles(end,:)), ts, duration);
            obj.trajectory = angles;
        end
        
        % Creates an animation using the 2 states
        function obj = CreateAnimation2States(statebegin, stateend, ts, duration)
            obj = Animation.Animation(statebegin, stateend, ts, duration);
            
            % Create smooth path
            t = [0 obj.duration];

            % Create the spline
            trajpoints = [obj.statebegin.angles; obj.stateend.angles];
            obj.trajectory = spline(t, trajpoints', obj.TimeVector)';
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
            tvector = obj.TimeVector;
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
        function obj = CreateAnimationHeadNodding(statecurrent, ts, duration, extent)
            obj = Animation.Animation(statecurrent, statecurrent, ts, duration);
            framecount = obj.FrameCount;
            
            % Create only the motion for the head
            headmotion = zeros(1,framecount);
            for i = 1:framecount/4
               headmotion(i) = i / (framecount/4) * extent;
            end
            for i = framecount/4:3*framecount/4
               headmotion(i) = (1 - (i - framecount/4)/(framecount/4)) * extent;
            end
            for i = 3*framecount/4:framecount
               headmotion(i) = ((i - 3*framecount/4)/(framecount/4)-1) * extent;
            end
            
            % Fill in the rest of trajectory
            obj.trajectory = zeros(framecount,20);
            for i = 1:framecount
               obj.trajectory(i,:) = statecurrent.angles;
            end
            obj.trajectory(:,18) = headmotion;
        end
        
        function obj = CreateAnimationHeadShaking(statecurrent, ts, duration, extent)
            obj = Animation.Animation(statecurrent, statecurrent, ts, duration);
            framecount = obj.FrameCount;
            
            % Create only the motion for the head
            headmotion = zeros(1,framecount);
            
            % Outwards
            for i = 1:framecount/4
               headmotion(i) = i / (framecount/4) * extent;
            end
            for i = framecount/4:3*framecount/4
               headmotion(i) = (1 - (i - framecount/4)/(framecount/4)) * extent;
            end
            for i = 3*framecount/4:framecount
               headmotion(i) = ((i - 3*framecount/4)/(framecount/4)-1) * extent;
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

