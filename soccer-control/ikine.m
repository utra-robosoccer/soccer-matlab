function q = ikine(dh, x6, y6, z6, g, q0)
%IKINE returns joint angles to produces ee position %%% OUT OF DATE
%   Q = IKINE(DH, X6, Z6, G, Q0)
% 
%   Uses an analytical inverse kinematics to produce the joint angles
%   required to produced the deisred position and orientation for the foot.
%
%
%   Arguments
%
%   DH = [6 x 4]
%       The denavit-hartenburg parameters responding to the 6 revolute
%       joints of the leg. The third element in each row is the link length,
%       and is the only relevant item.
%
%   X6, Y6, Z6 = [1 x 1]
%       The position of the foot end relative to hip
%
%   G = [1 x 1]
%       Vertical angle of the foot
%
%   Q0 = [1 x 1]
%       The angle of the foot in the x-y plane
%       
%
%   Outputs
%
%   Q = [6 x 1]
%       The joint angles produce by the inverse kinematics


% x6, y6, z6 are relative coordinates of end effector relative to hip
% g is the orientation in the x-y plane

    % lengths of links
    l1 = dh(3, 3); l2 = dh(4, 3); l3 = dh(6, 3);
    
    % polar distance and angle to end effector
    r = sqrt(x6^2 + y6^2);
    t = atan2(y6, x6);
    
    q = zeros(6, 1);
    
    % Hip angle to ensure angle of foot
    q(1) = -g;
    
    % Position of right before the end (ankle)
    z5 = z6 + l3;
    
    % Shift foot so that it is inline with desired position
    d = r * sin(g - t);
    q(2) = atan2(d, -z5);
    q(6) = -q(2);
    
    % Distance to ankle
    a = sqrt(d^2 + z5^2); % "Vertical"
    b = r * cos(g - t); % "Horizontal"
    dab = sqrt(a^2 + b^2);
    
    % is this position possible
    if (dab < l1 - l2 || dab > l1 + l2)
        error('Goal position is unreachable');
    end
    
    % use cosine  law to solve angles of triangle
    C1 = (l1^2 + dab^2 - l2^2)/(2*l1*dab);
    t1 = atan2(sqrt(1 - C1^2), C1);
    C2 = (l1^2 + l2^2 - dab^2)/(2*l1*l2);
    t2 = atan2(sqrt(1 - C2^2), C2);
    t3 = pi - t1 - t2;

    % construct the two possible q from data available
    qab = -atan2(a, b) + pi/2;
    q_a = [ qab + t1; t2 - pi; -qab + t3];
    q_b = [ qab - t1; pi - t2; -qab - t3];

    % choose the option closest to the previous answer
    if norm(q_a - q0(3:5)') < norm(q_b - q0(3:5)')
        q(3:5) = q_a;
    else
        q(3:5) = q_b;
    end
    
end