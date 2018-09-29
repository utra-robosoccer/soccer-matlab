function [trajectorySpline, trajectorySmooth] = createFixedTrajectory(trajectory, Ts, duration, Smooth)

    [l,~] = size(trajectory);
    t = linspace(0, duration, l); % # seconds to getup
    tspline = 0:Ts:duration;
    trajspline = spline(t, trajectory', tspline)';
    
    % Smooth the trajectory
    trajsmooth = trajspline;
    for i=1:20
        trajsmooth(:,i) = smooth(trajspline(:,i), Smooth);
    end
    
    % Electrical Convention
    trajsmoothelectrical = trajsmooth';
    temp = trajsmoothelectrical(1:6,:);
    trajsmoothelectrical(1,:) = temp(6,:);
    trajsmoothelectrical(2,:) = temp(5,:);
    trajsmoothelectrical(3,:) = temp(4,:);
    trajsmoothelectrical(4,:) = temp(3,:);
    trajsmoothelectrical(5,:) = temp(2,:);
    trajsmoothelectrical(6,:) = temp(1,:);
    trajsmoothelectrical = round(trajsmoothelectrical, 3);
    
    trajectorySpline = timeseries(trajspline, tspline);
    trajectorySmooth = timeseries(trajspline, tspline);
end

