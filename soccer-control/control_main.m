function angles = control_main
% Used to generate library, to run simulation use the run script
    start_pose = Pose(0, 0, 0, 0, 0);
    end_pose = Pose(0.5, 0, 0, 0, 0.0);
    command = Command.Command(start_pose);
    command.append(Command.ActionLabel.Forward, end_pose, 10);
    command.append(Command.ActionLabel.Forward, start_pose, 10);
    angles = zeros(12, 2000);
    cn = command.next();
    angles(:, 1) = [cn(1, :), cn(2, :)]';
end