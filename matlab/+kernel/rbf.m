function out = rbf(x, y, varargin)
% RBF  Compute the Radial Basis Function kernel.
%   OUT = KERNEL.RBF(X,Y)  Compute the RBF kernel defined as:
%
%     K(X,Y) = exp(-gamma * ||X - Y||^2)
%
%   Use KERNEL.RBF(..., 'gamma', GAMMA) to override the default value of
%   1/num_features.

% Author: Paolo D'Apice

opts.gamma = 1/size(x, 2);
opts = vl_argparse(opts, varargin);

out = exp(-opts.gamma .* pdist2(x, y).^2);
