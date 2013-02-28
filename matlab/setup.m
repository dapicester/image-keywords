% SETUP  Check the environment and set global variables.

fprintf('Checking environment\n');

% LIBSVM
fprintf('LIBSVM ... ');
if exist('svmtrain', 'file') ~= 3
    addpath('../dependencies/libsvm-3.16/matlab')
    fprintf('found, ');
end
fprintf('ok\n');

% VLFfeat
fprintf('VLFeat ... ');
if exist('vl_version', 'file') ~= 3
    run('../dependencies/vlfeat-0.9.16/toolbox/vl_setup')
    fprintf('found, ');
end
fprintf('ok\n');

% Parallel computing
if exist('matlabpool', 'file') == 2 && matlabpool('size') == 0
    matlabpool('open')
end

fprintf('Setting variables\n');

scaling = true;
fprintf('- scaling = %d\n', scaling);
