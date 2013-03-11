function out = linearKernel(x, y)
% LINEARKERNEL  Compute the linear kernel.
%   OUT = LINEARKERNEL(X, Y)  Compute the linear kernel defined as:
%
%     K(X, Y) = X * Y'

out = x * y';