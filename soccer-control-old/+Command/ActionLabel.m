classdef ActionLabel < uint8
    %ACTIONS Different labels for actions that the robot can perform
    
    enumeration
        Forward (0)         % Move forward
        Backward (1)        % Move backward
        Strafe (2)          % Move sideways forward
        Turn (3)            % Turn on spot
        Kick (4)            % Kick on spot
        Rest (5)            % Go to stopped position
        StanceLeft(6)       % Stance Left
        StanceRight(7)      % Stance Right
        SwingLeft(8)        % Swing Left Foot forward
        SwingRight(9)       % Swing Right Foot forward
        SwingLeftBack(10)   % Swing Left Foot backwards
        SwingRightBack(11)  % Swing Right Foot backwards
        FixStance (12)      % Go from straight to ready stance
    end
    
end

