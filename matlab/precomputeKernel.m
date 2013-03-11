function [traink, testk] = precomputeKernel(kernel, train, test)
% PRECOMPUTEKERNEL  Get LIBSVM data matrices for precomputed kernel.
%   [TRAIN2, TEST2] = PRECOMPUTEKERNEL(KERNEL, TRAIN, TEST)  Precompute the
%   kernel matrix defined by the function handle KERNEL on TRAIN and TEST
%   data.

traink = [ (1:size(train,1))', kernel(train, train)];
testk  = [ (1:size(test, 1))', kernel(test , train)];
