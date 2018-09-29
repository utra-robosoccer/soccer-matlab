stepr = Footstep(-0.025, 0, 0, Foot.Right, 0);
stepl = Footstep(0.025, 0, 0, Foot.Left, 0);
start = Pose(0, 0, 0, 0, 0.05);
final = Pose(0.5, 0, 0, 0, 0.05);
move = Movement(start, stepl, stepr);
angles = move.simulate(final, 10);
%%
format long e
test_data = angles;
% test_data = csvread("dataset_test.csv");    % Change the input file name
param_c = fopen('angles.h','w');             % Change the output file name
fprintf(param_c, '#define SIZE %d\n', (size(test_data,2)));
fprintf(param_c, '#define DIM %d\n\n', (size(test_data,1)));

fprintf(param_c, 'const double MOTORANGLES [DIM][SIZE] = {\n');
% Fixed Point Conversion
for i = 1:((size(test_data,1))/2)
    fprintf(param_c, '\t{');
    for j = 1:(size(test_data,2))
        a = test_data(7 - i,j);
        fprintf(param_c, '%.10f', a);
        if j ~= size(test_data,2)
            fprintf(param_c, ', ');
        end
    end
    fprintf(param_c, '},\n');
end
for i = 1:((size(test_data,1))/2)
    fprintf(param_c, '\t{');
    for j = 1:(size(test_data,2))
        a = test_data(i + 6,j);
        fprintf(param_c, '%.10f', a);
        if j ~= size(test_data,2)
            fprintf(param_c, ', ');
        end
    end
    fprintf(param_c, '},\n');
end
fprintf(param_c, '};\n\n');
fclose(param_c);