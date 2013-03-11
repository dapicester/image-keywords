function out = rbfKernel(x, y, varargin)
% RBFKERNEL  Compute the Radial Basis Function kernel.
%   OUT = RBFKERNEL(X,Y)  Compute the RBF kernel defined as:
%
%     K(X,Y) = exp(-gamma * ||X - Y||^2)
%
%   Use RBFKERNEL(..., 'gamma', GAMMA) to override the default value of
%   1/num_features.

opts.gamma = 1/size(x, 2);
opts = vl_argparse(opts, varargin);

out = exp(-opts.gamma .* pdist2(x, y).^2);
