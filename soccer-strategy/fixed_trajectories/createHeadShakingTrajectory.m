function searchBall = createHeadShakingTrajectory(resting)
%CREATEHEADTRAJECTORY Summary of this function goes here
%   Detailed explanation goes here
    headmotion = zeros(1,1000);
    for i=1:500
       headmotion(i) = (250-i)/250*pi/2;
    end
    for i=1:500
       headmotion(500+i) = (i-250)/250*pi/2;
    end
    findBallTraj = zeros(1000,20);
    for i=1:1000
       findBallTraj(i,:) = resting;
    end
    findBallTraj(:,17) = headmotion;
    findBallTrajTime = 0:0.01:length(findBallTraj)*0.01 - 0.01;
    
    searchBall = timeseries(findBallTraj, findBallTrajTime);
end

