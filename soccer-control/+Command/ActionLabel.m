classdef ActionLabel < uint8
    %ACTIONS Different labels for actions that the robot can perform
    
    %TODO expand and label once finalized with software team.
    enumeration
        Forward (0)
        Backward (1)
        Strafe (2)
        Turn (3)
        Kick (4)
        Rest (5)
        PrepareLeft(6)
        PrepareRight(7)
        FixStance (8)
    end
    
end

