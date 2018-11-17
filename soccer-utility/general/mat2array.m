function mat2array(data)
    test_data = data;
    % test_data = csvread("dataset_test.csv");    % Change the input file name
    param_c = fopen('angles.h','w');             % Change the output file name
    fprintf(param_c, '#define SIZE %d\n', (size(test_data,2)));
    fprintf(param_c, '#define DIM %d\n\n', (size(test_data,1)));

    fprintf(param_c, 'const double MOTORANGLES [DIM][SIZE] = {\n');
    % Fixed Point Conversion
    for i = 1:6
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
    for i = 1:6
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
    if size(test_data, 1) > 12
        for i = 1:4
            fprintf(param_c, '\t{');
            for j = 1:(size(test_data,2))
                a = test_data(i + 12,j);
                fprintf(param_c, '%.10f', a);
                if j ~= size(test_data,2)
                    fprintf(param_c, ', ');
                end
            end
            fprintf(param_c, '},\n');
        end
    end
    fprintf(param_c, '};\n\n');
    fclose(param_c);
end