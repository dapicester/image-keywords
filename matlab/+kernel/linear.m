function out = linear(x, y)
% LINEAR  Compute the linear kernel.
%   OUT = KERNEL.LINEAR(X, Y)  Compute the linear kernel defined as:
%
%     K(X, Y) = X * Y'

% Author: Paolo D'Apice

out = x * y';