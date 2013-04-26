function handle = printHandle(isVerbose)
% PRINTHANDLE  Get the stdout print handle.
%
%   HANDLE = PRINTHANDLE(ISVERBOSE)  Return @fprintf iff argument is TRUE.

% Author: Paolo D'Apice

handle = tif(isVerbose, @fprintf, @nop);


function nop(varargin)
% NOP  Does nothing.
