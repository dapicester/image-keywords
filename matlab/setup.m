% SETUP Check the evironment and set global variables.

fprintf('Checking environment ... ');

% vlfeat
if exist('vl_version', 'file') ~= 3
    run('../vlfeat/toolbox/vl_setup')
end

fprintf('done.\n');
