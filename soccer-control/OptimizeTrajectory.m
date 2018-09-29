function optimal = OptimizeTrajectory( starting )
%OPTIMIZETRAJECTORY Summary of this function goes here
%   Detailed explanation goes here
    
    model = 'biped_robot';
    load_system(model);
    parpool;
    
    spmd
        warning('off','all');
        % Setup tempdir and cd into it
        currDir = pwd;
        addpath(currDir);
        tmpDir = tempname;
        mkdir(tmpDir);
        cd(tmpDir);
        % Load the model on the worker
        load_system(model);
    end
    
    opt = optimoptions('fminunc', 'UseParallel', true, 'PlotFcn', {@optimplotfval, @optimplotfirstorderopt});
    lb = [0.8, 0, 0.8, 0, 0.75, 0.02, -0.01, 0.75, 0.25];
    ub = [1, 0.2, 1, 0.2, 1.5, 0.06, 0.01, 3, 1];
    optimal = fmincon(@objective_function, starting, [], [], [], [], lb, ub, [], opt);
    
    spmd
        cd(currDir);
        rmdir(tmpDir,'s');
        rmpath(currDir);
        close_system(model, 0);
    end
    
    close_system(model, 0);
    delete(gcp('nocreate'));
end

function val = objective_function(parameters)
    stepr = Footstep(-0.025, 0, 0, Foot.Right, 0);
    stepl = Footstep(0.025, 0, 0, Foot.Left, 0);
    start = Pose(0, 0, 0, 0, 0.05);
    final = Pose(0.5, 0, 0, 0, 0.05);
    move = Movement(start, stepl, stepr);
    
    move.forw_smoothing = parameters(1);
    move.forw_look_ahead = parameters(2);
    move.side_smoothing = parameters(3);
    move.side_look_ahead = parameters(4);
    move.switch_time = parameters(5);
    move.inward = parameters(6);
    move.leg_in = parameters(7);
    move.stance_time = parameters(8);
    move.swing_time = parameters(9);
    move.cycle_time = parameters(8) + parameters(9);
    
    try
        [~, data] = move.simulate(final, 10, 'SimulationMode', 'accelerator');
    catch
        val = Inf;
        return
    end
    
    data = squeeze(data.yout{1}.Values.Data);
    data(4,:) = 0;
    data(5:6, :) = data(5:6, :)/100;
    val = trapz(0.1*(0:10000), data.^2');
    val = sum(val);
end