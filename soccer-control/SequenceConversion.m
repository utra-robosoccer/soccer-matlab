function trajectories = SequenceConversion(varargin)
%SEQUENCECONVERSION interpolates between several joint positions 
%   SEQUENCECONVERSION(POSITIONS, DURATIONS)
%   SEQUENCECONVERSION(POSITIONS, DURATIONS, SPEEDS)
%   
%   Interpolation is done using Bezier curves. By default, it is assumed
%   that the speed at each position for each joint is zero; however, this
%   can be changed by supplying an optional speed variable.
%
%
%   Arguments
%
%   POSITIONS = [NUM_MOTORS x S]
%       The positions to be interpolated between.
%       S -> Number of states (positions) to be interpolated between
%
%   DURATIONS = [S - 1]
%       The duration of each transition. The ith duration corresponds to
%       the time between position i and position i+1.
%       S -> Number of states to be interpolated between.
%
%   SPEEDS = [NUM_MOTORS x S]       (optional)
%       The angular speed of each joint at the transition point. If not
%       supplied, initialized to all zeros.
%       S -> Number of states to be interpolated between.
%
%
%   Parameters
%
%   'File' := 'output.csv'
%       The file the generated trajectories are output to.
%   'Interval' := 0.01
%       The time interval used to generate the trajectories

NUM_MOTORS = 16;

%% Input Parsing
    
    p = inputParser();
    p.addRequired('positions', @(x) size(x, 1) == NUM_MOTORS && isnumeric(x));
    p.addRequired('durations', @(x) isvector(x) && isnumeric(x) || isempty(x));
    p.addOptional('speeds', [], @(x) size(x, 1) == NUM_MOTORS && isnumeric(x));
    p.addParameter('file', 'output.csv', @(x) ischar(x));
    p.addParameter('interval', 0.01, @(x) isscalar(x) && isnumeric(x));
    p.parse(varargin{:});
    
    positions = p.Results.positions;
    durations = p.Results.durations;
    speeds = p.Results.speeds;
    file = p.Results.file;
    update_interval = p.Results.interval;
    num_states = size(positions, 2);
    if isempty(speeds)
        speeds = zeros(NUM_MOTORS, num_states);
    end
    if size(positions, 2) ~= length(durations) + 1 || size(positions, 2) ~= size(speeds, 2)
        error('Number of states is not consistent');
    end
    
%% Trajectory Generation

    trajectories = zeros(16, floor(sum(durations) / update_interval));
    trajectories(:, 1) = positions(:, 1);
    last_time = 0;
    
    for i = 2:num_states
        % Create array of BezierTrajectories corresponding to each motor
        traj = BezierTrajectory(durations(i-1) * ones(NUM_MOTORS, 1), ...
            positions(:, i-1), positions(:, i), speeds(:, i-1), speeds(:, i));
        % Cycle through these trajectories over their duration and store
        for t = update_interval:update_interval:durations(i-1)
            trajectories(:, round(t/update_interval + last_time/update_interval)) = ...
                arrayfun(@(x) x.positionAtTime(t), traj);
        end
        % Update the time curresponding to the last position
        last_time = last_time + durations(i-1);
    end

%% Output to File    

%     csvwrite(file, trajectories);
    
end