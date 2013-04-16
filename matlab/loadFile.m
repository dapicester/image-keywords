function data = loadFile(filename)
% LOADFILE  Load data from file.
%   Actually this is a wrapper around the built-in load() function 
%   surrounded with a try/catch block.
%
% See also LOAD.

% Author: Paolo D'Apice

try
    data = load(filename);
catch err
    error(err.message)
end
