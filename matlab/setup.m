% SETUP  Check the environment and set global variables.

% Author: Paolo D'Apice

fprintf('Checking environment:\n');

global ROOT_DIR DATA_DIR
ROOT_DIR = fileparts(pwd);
DATA_DIR = fullfile(ROOT_DIR, 'data');

% LIBSVM
fprintf('- LIBSVM ... ');
if exist('svmtrain', 'file') ~= 3
    error('cannot find LIBSVM');
end
fprintf('ok\n');

% VLFfeat
fprintf('- VLFeat ... ');
if exist('vl_version', 'file') ~= 3
    error('cannot find VLFeat');
end
fprintf('ok\n');

% Parallel computing
fprintf('- Matlab workers pool ... ')
if exist('matlabpool', 'file') == 0
    fprintf('no\n');
elseif exist('matlabpool', 'file') == 2 && matlabpool('size') == 0
    matlabpool('open')
else
    fprintf('ok\n');
end

fprintf('Setting variables:\n');

global SCALING
SCALING = false;
fprintf('- scaling = %d\n', SCALING);

fprintf('\n');
