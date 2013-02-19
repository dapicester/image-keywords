% SETUP Check the evironment and set global variables.

% vlfeat
if exist('vl_version', 'file') ~= 3
    run('../vlfeat/toolbox/vl_setup')
end

fprintf('Environment check done.\n');
