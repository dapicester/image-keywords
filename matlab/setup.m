% SETUP: check the evironment and set global variables

% vlfeat
if exist('vl_version', 'file') ~= 3
    error('vlfeat is required')
end
