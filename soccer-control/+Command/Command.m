classdef Command < handle
    %COMMAND Control of the entire robot movement
    
    properties
        % High-level actions and idealized path
        actions
        prepared_side = Footsteps.Foot.Left;
        
        % Body physical parameters
        hip_height = 0.16;
        hip_width = 0.0315;
        dh = [
            0.0280     -pi/2         0      pi/2
                 0      pi/2         0     -pi/2
                 0         0    0.0930         0
                 0         0    0.0827         0
                 0         0         0      pi/2
                 0         0    0.0253         0
        ];
        
        % Movement timing parameters
        swing_time = 0.5;
        stance_time = 1.5;
        cycle_time = 2;
        
        % Movement physical parameters
        step_height = 0.05;
        angles = zeros(2,6);
        %%% TODO separate into left and right, fix timing
        footsteps
        foot_pos
        %%%
        body_pose = Pose(0, -0.0, 0, 0, 0);
        cur_angles = zeros(2,6);
        
        % Trajectories
        foot_traj_l
        foot_traj_r
        body_traj 
        
        % Kicking Parameters
        kick_prep_dist = 0.05;
        kick_forw_dist = 0.12;
        kick_time = 0.5; % NOT FULLY IMPLEMENTED
        kick_height = 0.04; % NOT IMPLEMENTED
        
        % Low level stuff
        secant_size = 0.001;
        idx = 0
    end
    
    methods (Hidden)
        
        function label = getCurrentLabel(obj)
            if obj.actions.transitions(1) - obj.actions.current_time > ...
                    obj.actions.increment - 1e-5
                label = obj.actions.data{1}.label;
            else
                label = obj.actions.data{2}.label;
            end
        end
        
        %TODO this is not the right place for this function
        function traj = buildBodyTraj(obj, init_time, ...
                init_step, fin_step, duration)
        %BUILDBODYTRAJ builds body trajectory between footsteps
        %   TRAJ = BUILDBODYTRAJ(OBJ, INIT_TIME, INIT_STEP, ...
        %       FIN_STEP, DURATION)
        %
        %   BUILDBODYTRAJ constructs a smoothed trajectory for the body to
        %   follow between footsteps. This is done with bezier curves,
        %   allowing trajectory to precisely match foot tajectory when
        %   needed.
        %
        %
        %   Arguments
        %
        %   INIT_TIME = [1 x 1] 
        %       How far into the future from the current time to construct
        %       the body trajectory.
        %
        %   INIT_STEP = [1 x 1] Pose
        %       The initial position of the body.
        %
        %   FIN_STEP = [1 x 1] Pose
        %       The final position of the body.
        %
        %   DURATION = [1 x 1]
        %       How long the trajectory should take.
        %
        %
        %   Outputs
        %
        %   TRAJ = [1 x 1] Trajectories.Trajectory(dim=2)
        %       The two-dimensional body trajectory.
            init_pos = init_step - obj.actions.positionAtTime(init_time);
            fin_pos = fin_step - obj.actions.positionAtTime(init_time + duration);
            init_speed = -obj.actions.speedAtTime(init_time);
            fin_speed = -obj.actions.speedAtTime(init_time + duration);
            
            %Ensure continuous rotations
            iq = mod(init_pos.q, 2*pi); fq = mod(fin_pos.q, 2*pi);
            if abs(fq - iq) > pi
                if abs(fq) > abs(iq)
                    fq = fq - 2 * pi;
                else
                    iq = iq - 2 * pi;
                end
            end
            
            traj = Trajectories.Trajectory();
            traj.data = {
                Trajectories.BezierTrajectory(duration, ...
                    init_pos.x, fin_pos.x, init_speed.x, fin_speed.x);
                Trajectories.BezierTrajectory(duration, ...
                    init_pos.y, fin_pos.y, init_speed.y, fin_speed.y);
                Trajectories.BezierTrajectory(duration, ...
                    init_pos.z, fin_pos.z, init_speed.z, fin_speed.z);
                Trajectories.BezierTrajectory(duration, ...
                    iq, fq, init_speed.q, fin_speed.q);
                Trajectories.BezierTrajectory(duration, ...
                    init_pos.v, fin_pos.v, init_speed.v, fin_speed.v)
            };
            traj.duration = duration;
        end
        
        function generateNextFootstep(obj)
        %GENERATENEXTFOOTSTEP produces the next footstep along the path
        %   GENERATENEXTFOOTSTEPS(OBJ)

            step_duration = obj.cycle_time / 2;
            step_width = obj.hip_width;
            init_pose = obj.actions.positionAtTime(0);
            next_pose = obj.actions.positionAtTime(obj.cycle_time / 2);
            label = obj.getCurrentLabel();
            
            if label == Command.ActionLabel.PrepareLeft || ...
                    obj.footsteps.positionAtTime(0).side == Footsteps.Foot.Right
                last_step = obj.foot_pos{1};
            else
                last_step = obj.foot_pos{2};
            end
            
            if label == Command.ActionLabel.Forward || ...
                    label == Command.ActionLabel.Backward
                ninc_pose = obj.actions.positionAtTime(obj.cycle_time / 2 + obj.secant_size);
                delt_pose = ninc_pose - next_pose;
                %Find normal, and flip the direction depending on step side
                normalv = [-delt_pose.y, delt_pose.x];
                if xor(last_step.side == Footsteps.Foot.Left, ...
                        label == Command.ActionLabel.Backward)
                    normalv = -normalv;
                end

                %Find position of next footstep based on normal and d
                next_step = [next_pose.x next_pose.y] ...
                    - normalv/norm(normalv) * step_width;
                %Angle q of the nextfootstep
                next_q = atan2(delt_pose.y, delt_pose.x);
                if label == Command.ActionLabel.Backward
                    next_q = mod(next_q + pi, 2 * pi);
                end
            elseif label == Command.ActionLabel.Strafe
                next_q = next_pose.q;

                % Calculate the footposition (offset)
                normalv = [-sin(next_q) cos(next_q)];
                if last_step.side == Footsteps.Foot.Left
                    normalv = -normalv;
                end
                next_step = [next_pose.x next_pose.y] ...
                    - normalv/norm(normalv) * step_width;
                
            elseif label == Command.ActionLabel.Turn || ...
                    label == Command.ActionLabel.FixStance
                next_q = next_pose.q;

                % Calculate the footposition (offset)
                normalv = [-sin(next_q) cos(next_q)];
                if last_step.side == Footsteps.Foot.Left
                    normalv = -normalv;
                end
                next_step = [init_pose.x init_pose.y] - normalv/norm(normalv) * step_width;
                
            else % Keep feet as they are
                if label == Command.ActionLabel.Kick
                    footstep = Footsteps.Footstep(...
                        last_step.x - obj.kick_prep_dist * cos(last_step.q), ...
                        last_step.y - obj.kick_prep_dist * sin(last_step.q), ...
                        0, last_step.side, obj.swing_time ...
                    );
                    obj.footsteps.append(footstep);
                    footstep = Footsteps.Footstep(...
                        footstep.x + obj.kick_forw_dist * cos(last_step.q), ...
                        footstep.y + obj.kick_forw_dist * sin(last_step.q), ...
                        0, last_step.side, obj.kick_time ...
                    );
                    obj.footsteps.append(footstep);
                end
                next_step = [last_step.x, last_step.y];
                next_q = last_step.q;
                step_duration = obj.swing_time;
            end
            

            % Create the footstep
            footstep = Footsteps.Footstep(next_step(1), next_step(2), ...
                next_q, last_step.side, step_duration);
            obj.footsteps.append(footstep);
        end
        
    end
    
    methods
        function obj = Command(start_pose)
        %COMMAND initializes the command object
        %   OBJ = COMMAND(START_POS)
        %
        %   
        %   Arguments
        %
        %   START_POS = [1 x 1] Pose
        %       Where the robot starts.
            obj.body_pose = start_pose;
            
            % Initial Foot Positions
            obj.foot_pos = {
                Footsteps.Footstep(-obj.hip_width * sin(start_pose.q), ...
                                    obj.hip_width * cos(start_pose.q), ...
                                    start_pose.q, Footsteps.Foot.Left, 0),... 
                Footsteps.Footstep( obj.hip_width * sin(start_pose.q), ...
                                   -obj.hip_width * cos(start_pose.q), ...
                                    start_pose.q, Footsteps.Foot.Right, 0)
            }; % L, R
            
            % Initialize queues
            obj.actions = Trajectories.LiveQueue(Command.Action(...
                Command.ActionLabel.Forward,Pose(0,0,0,0,0),Pose(0,0,0,0,0),0));
            obj.footsteps = Trajectories.LiveQueue(Footsteps.Footstep(), false);
            obj.foot_traj_l = Trajectories.LiveQueue(Trajectories.FootCycle(...
                obj.actions, obj.foot_pos{1}, obj.foot_pos{2}, 0, 0, 0));
            obj.foot_traj_r = Trajectories.LiveQueue(Trajectories.FootCycle(...
                obj.actions, obj.foot_pos{1}, obj.foot_pos{2}, 0, 0, 0));
            centered_pose = Pose.centeredPose(obj.foot_pos{1}, obj.foot_pos{2});
            obj.body_traj = Trajectories.LiveQueue(obj.buildBodyTraj(...
                0, centered_pose, centered_pose, 0));
            
            % Determines the initial joint angle of the robot
            %TODO should not depend on footstep position
            obj.cur_angles(1,3) = 1;
            obj.cur_angles(2,3) = 1;
            obj.cur_angles(1,:) = ikine(obj.dh, ...
                obj.foot_pos{1}.x + obj.hip_width * sin(start_pose.q), ...
                obj.foot_pos{1}.y - obj.hip_width * cos(start_pose.q), ...
                -obj.hip_height, 0, obj.cur_angles(1,:));
            obj.cur_angles(2,:) = ikine(obj.dh, ...
                obj.foot_pos{2}.x - obj.hip_width * sin(start_pose.q), ...
                obj.foot_pos{2}.y + obj.hip_width * cos(start_pose.q), ...
                -obj.hip_height, 0, obj.cur_angles(2,:));
        end
        
        function angles = next(obj)
        %NEXT produces the next set of joint angles
        %   ANGLES = NEXT(OBJ)
        %
        %   This is the main method for the COMMAND object. This method
        %   advances time forward and keeps track of all important changes
        %   that result from this. It then determines the current angles
        %   based on this.
        %
        %
        %   Outputs
        %
        %   Angles = [2 x 6]
        %       The 12 angles corresponding to the current desired angular
        %       position.
            obj.idx = obj.idx + 1;
            
            if obj.footsteps.isempty() && ~obj.actions.isempty()
                obj.generateNextFootstep();
            end
            footstep = obj.footsteps.next();
            action = obj.actions.next();
            label = obj.getCurrentLabel();
            if (label == Command.ActionLabel.PrepareLeft || ...
                    label == Command.ActionLabel.PrepareRight || ...
                    label == Command.ActionLabel.Rest) ... 
                    && obj.body_traj.isempty()
                obj.foot_traj_l.append(Trajectories.FootCycle( ...
                    obj.actions, obj.foot_pos{1}, obj.foot_pos{1}, ...
                    0, obj.swing_time, obj.swing_time ...
                ));
                obj.foot_traj_r.append(Trajectories.FootCycle( ...
                    obj.actions, obj.foot_pos{2}, obj.foot_pos{2}, ...
                    0, obj.swing_time, obj.swing_time ...
                ));
                if label == Command.ActionLabel.PrepareLeft
                    obj.prepared_side = Footsteps.Foot.Left;
                    obj.body_traj.append(obj.buildBodyTraj( ...
                        0, obj.body_traj.positionAtTime(0), ...
                        obj.foot_pos{1}, obj.swing_time ...
                    ));
                elseif label == Command.ActionLabel.PrepareRight
                    obj.prepared_side = Footsteps.Foot.Right;
                    obj.body_traj.append(obj.buildBodyTraj( ...
                        0, obj.body_traj.positionAtTime(0), ...
                        obj.foot_pos{2}, obj.swing_time ...
                    ));
                elseif label == Command.ActionLabel.Rest
                    centered_pose = Pose.centeredPose(obj.foot_pos{1}, obj.foot_pos{2});
                    obj.body_traj.append(obj.buildBodyTraj( ...
                        0, obj.body_traj.positionAtTime(0) + action, ...
                        centered_pose, obj.swing_time ...
                    ));
                end
                
            %TODO Figure out how to remove if statement to reduce repistion
            elseif footstep.side == Footsteps.Foot.Left && ...
                    footstep ~= obj.foot_pos{1}
                % Build new trajectories for feet to reach next footstep
                obj.foot_traj_l.append(Trajectories.FootCycle( ...
                    obj.actions, obj.foot_pos{1}, footstep, ...
                    obj.step_height, obj.swing_time, footstep.duration ...
                ));
                obj.foot_traj_r.append(Trajectories.FootCycle( ...
                    obj.actions, obj.foot_pos{2}, obj.foot_pos{2}, ...
                    obj.step_height, 0, footstep.duration ...
                ));
                obj.body_traj.append(obj.buildBodyTraj( ...
                    0, obj.foot_pos{2}, ...
                    obj.foot_pos{2}, obj.swing_time ...
                ));
                if label ~= Command.ActionLabel.Kick
                    obj.body_traj.append(obj.buildBodyTraj( ...
                        obj.swing_time, obj.foot_pos{2}, ...
                        footstep, obj.cycle_time / 2 - obj.swing_time ...
                    ));
                end
                obj.foot_pos{1} = footstep;
            elseif footstep.side == Footsteps.Foot.Right && ...
                    footstep ~= obj.foot_pos{2}
                % Build new trajectories for feet to reach next footstep
                obj.foot_traj_l.append(Trajectories.FootCycle( ...
                    obj.actions, obj.foot_pos{1}, obj.foot_pos{1}, ...
                    obj.step_height, 0, footstep.duration ...
                ));
                obj.foot_traj_r.append(Trajectories.FootCycle( ...
                    obj.actions, obj.foot_pos{2}, footstep, ...
                    obj.step_height, obj.swing_time, footstep.duration ...
                ));
                obj.body_traj.append(obj.buildBodyTraj( ...
                    0, obj.foot_pos{1}, ...
                    obj.foot_pos{1}, obj.swing_time ...
                ));
                if label ~= Command.ActionLabel.Kick
                    obj.body_traj.append(obj.buildBodyTraj( ...
                        obj.swing_time, obj.foot_pos{1}, ...
                        footstep, obj.cycle_time / 2 - obj.swing_time ...
                    ));
                end
                obj.foot_pos{2} = footstep;
            end
            ftl = obj.foot_traj_l.next();
            ftr = obj.foot_traj_r.next();
            bp = obj.body_traj.next();
            
            % Transform from world frame to body frame
            abq = action.q + bp.q;
            lx = ftl.x - bp.x + obj.hip_width * sin(abq);
            ly = ftl.y - bp.y - obj.hip_width * cos(abq);
            rx = ftr.x - bp.x - obj.hip_width * sin(abq);
            ry = ftr.y - bp.y + obj.hip_width * cos(abq);
            lr = sqrt(lx^2 + ly^2);
            rr = sqrt(rx^2 + ry^2);
            lq = atan2(ly, lx) - abq;
            rq = atan2(ry, rx) - abq;
            
            obj.cur_angles(1,:) = ikine(obj.dh, ...
                lr * cos(lq), lr * sin(lq), ...
                ftl.z - obj.hip_height, ...
                mod(ftl.q - bp.q + pi, 2*pi) - pi, ...
                obj.cur_angles(1,:) ...
            );
            obj.cur_angles(2,:) = ikine(obj.dh, ...
                rr * cos(rq), rr * sin(rq), ...
                ftr.z - obj.hip_height, ...
                mod(ftr.q - bp.q + pi, 2*pi) - pi, ...
                obj.cur_angles(2,:) ...
            );
            angles = obj.cur_angles;
        end
        
        function append(obj, label, goal, duration)
        %APPEND adds a new action to the action queue
        %   APPEND(OBJ, LABEL, GOAL, DURATION)
        %
        %   Construct a new action based on the provided inputs and appends
        %   it to the queue. Also update other parameters as needed.
        %
        %
        %   Arguments
        %
        %   LABEL = [1 x 1] Command.ActionLabel
        %       The desired type of action.
        %
        %   GOAL = [1 x 1] Pose
        %       The desired final position
        %
        %   DURATION = [1 x 1]
        %       The desired duration of the action.
            if label == Command.ActionLabel.PrepareLeft || ...
                    label == Command.ActionLabel.PrepareLeft || ...
                    label == Command.ActionLabel.Rest
                duration = obj.cycle_time / 2 - obj.swing_time;
            elseif label == Command.ActionLabel.FixStance
                duration = obj.cycle_time / 2;
            elseif label == Command.ActionLabel.Kick
                duration = obj.swing_time * 2 + obj.kick_time;
            end
            
            if ~isempty(obj.actions)
                action = Command.Action( ...
                    label, obj.actions.data{obj.actions.length}.goal, ...
                    goal, duration ...
                );
            else
                action = Command.Action( ...
                    label, obj.body_pose, goal, duration ...
                );
            end
            obj.body_pose = goal;
            obj.actions.append(action);
        end
    end
    
end

