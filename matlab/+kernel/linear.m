function out = linear(x, y)
% KERNEL.LINEAR  Compute the linear kernel.
%   OUT = KERNEL.LINEAR(X, Y)  Compute the linear kernel defined as:
%
%     K(X, Y) = X * Y'

out = x * y';