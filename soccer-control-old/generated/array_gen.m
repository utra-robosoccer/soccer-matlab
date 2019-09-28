%% Author: Shahryar Rajabzadeh
%  May 2017
%% Purpose: Generate C include files from .csv files for linear kernel SVM
%  Using Fixed-Point toolbox, it prepares data for processors without
%  floating point support.
%% Input data format
% 
%
% dataset.csv:
% Class | Dim1 | Dim 2 | ...
%    |      |      |
%    V      V      V
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% param.csv:
% w1
% w2
% .
% .
% .
% b
%%
format decimal
test_data = csvread("dataset_test.csv");    % Change the input file name
param_c = fopen('param.h','w');             % Change the output file name
fprintf(param_c, '#define DIM %d\n', (size(test_data,2)));
fprintf(param_c, '#define SIZE %d\n\n', (size(test_data,1)));

fprintf(param_c, 'const double trajectories [SIZE][DIM] = {\n');
% Fixed Point Conversion
for i = 1:(size(test_data,1))
    fprintf(param_c, '\t{');
    for j = 1:(size(test_data,2))
        a = test_data(i,j);
        fprintf(param_c, '0x%s', a);
        if j ~= size(test_data,2)
            fprintf(param_c, ', ');
        end
    end
    fprintf(param_c, '},\n');
end
fprintf(param_c, '};\n\n');
fclose(param_c);
