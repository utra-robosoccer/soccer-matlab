classdef Foot < uint8
    %FOOT enumerates foot sides
    
    enumeration
        Left (0)
        Right (1)
    end
    
    methods
        
        function obj = not(obj)
        %NOT returns the opposite foot
            if obj == Foot.Left
                obj = Foot.Right;
            else
                obj = Foot.Left;
            end
        end
        
    end
    
end

