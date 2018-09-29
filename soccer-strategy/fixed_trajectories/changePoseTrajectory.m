function trajectory = changePoseTrajectory(startPose, endPose, Ts, duration) 
    t = [0 duration];
    tsmooth = 0:Ts:duration; % 3 seconds
    trajectoryPoints = [startPose; endPose];
    traj = spline(t, trajectoryPoints', tsmooth)';
    trajectory = timeseries(traj, tsmooth);
end