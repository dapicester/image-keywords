function [traink, testk] = precomputeKernel(kernel, train, varargin)
% PRECOMPUTEKERNEL  Get LIBSVM data matrices for precomputed kernel.
%
%   MAPPED = PRECOMPUTEKERNEL(KERNEL, DATA)  Precompute the kernel matrix
%   defined by the function hanle KERNEL on DATA.
%
%   [TRAINK, TESTK] = PRECOMPUTEKERNEL(KERNEL, TRAIN, TEST)  Precompute
%   the kernel matrix defined by the function handle KERNEL on TRAIN and 
%   TEST data.

traink = [ (1:size(train,1))', kernel(train, train)];
if nargin == 3
    test = varargin{1};
    testk  = [ (1:size(test, 1))', kernel(test , train)];
end
