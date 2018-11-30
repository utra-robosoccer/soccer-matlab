classdef MotorFeedback

    properties
        stanceLeft
        stanceRight
        swingLeft
        swingRight
        
        rightHipSideFront
        rightHipFrontThigh
        rightCalveAnkle
        rightAnkleFoot
        
        leftHipSideFront
        leftHipFrontThigh
        leftCalveAnkle
        leftAnkleFoot
        
        desiredAngle
    end
    
    methods
        function obj = MotorFeedback(stanceLeft,stanceRight,swingLeft,swingRight)
            obj.stanceLeft = stanceLeft;
            obj.stanceRight = stanceRight;
            obj.swingLeft = swingLeft;
            obj.swingRight = swingRight;
            
            % Organize in simulink readable format
            obj.rightHipSideFront.pitch.stanceLeft = obj.stanceLeft.pitch.rightHipSideFront;
            obj.rightHipSideFront.pitch.stanceRight = obj.stanceRight.pitch.rightHipSideFront;
            obj.rightHipSideFront.pitch.swingLeft = obj.swingLeft.pitch.rightHipSideFront;
            obj.rightHipSideFront.pitch.swingRight = obj.swingRight.pitch.rightHipSideFront;
            
            obj.rightHipFrontThigh.pitch.stanceLeft = obj.stanceLeft.pitch.rightHipFrontThigh;
            obj.rightHipFrontThigh.pitch.stanceRight = obj.stanceRight.pitch.rightHipFrontThigh;
            obj.rightHipFrontThigh.pitch.swingLeft = obj.swingLeft.pitch.rightHipFrontThigh;
            obj.rightHipFrontThigh.pitch.swingRight = obj.swingRight.pitch.rightHipFrontThigh;
            
            obj.rightCalveAnkle.pitch.stanceLeft = obj.stanceLeft.pitch.rightCalveAnkle;
            obj.rightCalveAnkle.pitch.stanceRight = obj.stanceRight.pitch.rightCalveAnkle;
            obj.rightCalveAnkle.pitch.swingLeft = obj.swingLeft.pitch.rightCalveAnkle;
            obj.rightCalveAnkle.pitch.swingRight = obj.swingRight.pitch.rightCalveAnkle;
            
            obj.rightAnkleFoot.pitch.stanceLeft = obj.stanceLeft.pitch.rightAnkleFoot;
            obj.rightAnkleFoot.pitch.stanceRight = obj.stanceRight.pitch.rightAnkleFoot;
            obj.rightAnkleFoot.pitch.swingLeft = obj.swingLeft.pitch.rightAnkleFoot;
            obj.rightAnkleFoot.pitch.swingRight = obj.swingRight.pitch.rightAnkleFoot;
            
            obj.leftHipSideFront.pitch.stanceLeft = obj.stanceLeft.pitch.leftHipSideFront;
            obj.leftHipSideFront.pitch.stanceRight = obj.stanceRight.pitch.leftHipSideFront;
            obj.leftHipSideFront.pitch.swingLeft = obj.swingLeft.pitch.leftHipSideFront;
            obj.leftHipSideFront.pitch.swingRight = obj.swingRight.pitch.leftHipSideFront;
            
            obj.leftHipFrontThigh.pitch.stanceLeft = obj.stanceLeft.pitch.leftHipFrontThigh;
            obj.leftHipFrontThigh.pitch.stanceRight = obj.stanceRight.pitch.leftHipFrontThigh;
            obj.leftHipFrontThigh.pitch.swingLeft = obj.swingLeft.pitch.leftHipFrontThigh;
            obj.leftHipFrontThigh.pitch.swingRight = obj.swingRight.pitch.leftHipFrontThigh;
            
            obj.leftCalveAnkle.pitch.stanceLeft = obj.stanceLeft.pitch.leftCalveAnkle;
            obj.leftCalveAnkle.pitch.stanceRight = obj.stanceRight.pitch.leftCalveAnkle;
            obj.leftCalveAnkle.pitch.swingLeft = obj.swingLeft.pitch.leftCalveAnkle;
            obj.leftCalveAnkle.pitch.swingRight = obj.swingRight.pitch.leftCalveAnkle;
            
            obj.leftAnkleFoot.pitch.stanceLeft = obj.stanceLeft.pitch.leftAnkleFoot;
            obj.leftAnkleFoot.pitch.stanceRight = obj.stanceRight.pitch.leftAnkleFoot;
            obj.leftAnkleFoot.pitch.swingLeft = obj.swingLeft.pitch.leftAnkleFoot;
            obj.leftAnkleFoot.pitch.swingRight = obj.swingRight.pitch.leftAnkleFoot;
            
            obj.rightHipSideFront.roll.stanceLeft = obj.stanceLeft.roll.rightHipSideFront;
            obj.rightHipSideFront.roll.stanceRight = obj.stanceRight.roll.rightHipSideFront;
            obj.rightHipSideFront.roll.swingLeft = obj.swingLeft.roll.rightHipSideFront;
            obj.rightHipSideFront.roll.swingRight = obj.swingRight.roll.rightHipSideFront;
            
            obj.rightHipFrontThigh.roll.stanceLeft = obj.stanceLeft.roll.rightHipFrontThigh;
            obj.rightHipFrontThigh.roll.stanceRight = obj.stanceRight.roll.rightHipFrontThigh;
            obj.rightHipFrontThigh.roll.swingLeft = obj.swingLeft.roll.rightHipFrontThigh;
            obj.rightHipFrontThigh.roll.swingRight = obj.swingRight.roll.rightHipFrontThigh;
            
            obj.rightCalveAnkle.roll.stanceLeft = obj.stanceLeft.roll.rightCalveAnkle;
            obj.rightCalveAnkle.roll.stanceRight = obj.stanceRight.roll.rightCalveAnkle;
            obj.rightCalveAnkle.roll.swingLeft = obj.swingLeft.roll.rightCalveAnkle;
            obj.rightCalveAnkle.roll.swingRight = obj.swingRight.roll.rightCalveAnkle;
            
            obj.rightAnkleFoot.roll.stanceLeft = obj.stanceLeft.roll.rightAnkleFoot;
            obj.rightAnkleFoot.roll.stanceRight = obj.stanceRight.roll.rightAnkleFoot;
            obj.rightAnkleFoot.roll.swingLeft = obj.swingLeft.roll.rightAnkleFoot;
            obj.rightAnkleFoot.roll.swingRight = obj.swingRight.roll.rightAnkleFoot;
            
            obj.leftHipSideFront.roll.stanceLeft = obj.stanceLeft.roll.leftHipSideFront;
            obj.leftHipSideFront.roll.stanceRight = obj.stanceRight.roll.leftHipSideFront;
            obj.leftHipSideFront.roll.swingLeft = obj.swingLeft.roll.leftHipSideFront;
            obj.leftHipSideFront.roll.swingRight = obj.swingRight.roll.leftHipSideFront;
            
            obj.leftHipFrontThigh.roll.stanceLeft = obj.stanceLeft.roll.leftHipFrontThigh;
            obj.leftHipFrontThigh.roll.stanceRight = obj.stanceRight.roll.leftHipFrontThigh;
            obj.leftHipFrontThigh.roll.swingLeft = obj.swingLeft.roll.leftHipFrontThigh;
            obj.leftHipFrontThigh.roll.swingRight = obj.swingRight.roll.leftHipFrontThigh;
            
            obj.leftCalveAnkle.roll.stanceLeft = obj.stanceLeft.roll.leftCalveAnkle;
            obj.leftCalveAnkle.roll.stanceRight = obj.stanceRight.roll.leftCalveAnkle;
            obj.leftCalveAnkle.roll.swingLeft = obj.swingLeft.roll.leftCalveAnkle;
            obj.leftCalveAnkle.roll.swingRight = obj.swingRight.roll.leftCalveAnkle;
            
            obj.leftAnkleFoot.roll.stanceLeft = obj.stanceLeft.roll.leftAnkleFoot;
            obj.leftAnkleFoot.roll.stanceRight = obj.stanceRight.roll.leftAnkleFoot;
            obj.leftAnkleFoot.roll.swingLeft = obj.swingLeft.roll.leftAnkleFoot;
            obj.leftAnkleFoot.roll.swingRight = obj.swingRight.roll.leftAnkleFoot;
            
            obj.desiredAngle.roll.swingRight = obj.swingRight.roll.desiredAngle;
            obj.desiredAngle.pitch.swingRight = obj.swingRight.pitch.desiredAngle;
            obj.desiredAngle.roll.swingLeft = obj.swingLeft.roll.desiredAngle;
            obj.desiredAngle.pitch.swingLeft = obj.swingLeft.pitch.desiredAngle;
            obj.desiredAngle.roll.stanceRight = obj.stanceRight.roll.desiredAngle;
            obj.desiredAngle.pitch.stanceRight = obj.stanceRight.pitch.desiredAngle;
            obj.desiredAngle.roll.stanceLeft = obj.stanceLeft.roll.desiredAngle;
            obj.desiredAngle.pitch.stanceLeft = obj.stanceLeft.pitch.desiredAngle;
        end
    end
end

