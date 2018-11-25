classdef ActionState < uint8
    %ACTIONSTATE The current movement done by the forward trajectory
    
    enumeration
        Default(0)
        LeftSwing(1)
        LeftToRightStance(2)
        RightSwing(3)
        RightToLeftStance(4)
    end
end

