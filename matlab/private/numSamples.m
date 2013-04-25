function num = numSamples(len, ratio, max)
% NUMSAMPLES  Return the ration of a number limited to a maximum.

% Author: Paolo D'Apice
num = min(floor(len * ratio), max);
