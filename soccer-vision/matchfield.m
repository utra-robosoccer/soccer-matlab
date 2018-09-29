function [newRobotPose] = matchfield(screenpoints, robotPose)
    soccerfield;
    
    % Define the data
    M = soccerfieldpoints';
    D = screenpoints(any(screenpoints,2),:)';
    M(3,1) = 0;
    D(3,1) = 0;
    [~,w] = size(D);
    if(w == 0)
        newRobotPose = robotPose;
        return;
    end
    
    % Transform the data first
    Dfixed = robotPose(1:3,1:3) * D + repmat(robotPose(1:3,4), 1, w);
    
    % Do the ICP
    [Ricp, Ticp, ~, ~] = icp(M, Dfixed, 15);

    % Transform data-matrix using ICP result
    Dicp = Ricp * Dfixed + repmat(Ticp, 1, w);

    % Return new transformation relative to D
    Ticp = 0.1 * Ticp; % Slow down translations
    rotMatNew = [Ricp, Ticp; 0,0,0,1];
    newRobotPose = rotMatNew * robotPose;
    
    
    % Plot model points blue and transformed points red
    subplot(1,2,1);
    plot(M(1,:),M(2,:),'bo',Dfixed(1,:),Dfixed(2,:),'r.');
    xlabel('x'); ylabel('y'); zlabel('z');
    title('Red: z=sin(x)*cos(y), blue: transformed point cloud');
    ylim([-9000,9000]); % 5 meters
    xlim([-5000 5000]);
    grid on;
    
    % Plot the results
    subplot(1,2,2);
    plot(M(1,:),M(2,:),'bo',Dicp(1,:),Dicp(2,:),'r.');
    xlabel('x'); ylabel('y'); zlabel('z');
    title('ICP result');
    ylim([-9000,9000]); % 5 meters
    xlim([-5000 5000]);
    grid on;
    
    % Plot the position
    hold on;
    plot(robotPose(1,4), robotPose(2,4), '+');
    hold off;
end