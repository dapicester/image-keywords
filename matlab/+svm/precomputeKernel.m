function [traink, varargout] = precomputeKernel(kernel, train, varargin)
% PRECOMPUTEKERNEL  Get LIBSVM data matrices for precomputed kernel.
%
%   MAPPED = SVM.PRECOMPUTEKERNEL(KERNEL, DATA)  Precompute the kernel 
%   matrix defined by the function hanle KERNEL on DATA.
%
%   [TRAINK, TESTK] = SVM.PRECOMPUTEKERNEL(KERNEL, TRAIN, TEST) Precompute
%   the kernel matrix defined by the function handle KERNEL on TRAIN and 
%   TEST data.
%
%   [TRAINK, ...] = SVM.PRECOMPUTEKERNEL(KERNEL, TRAIN, ...) 
%   Precompute the kernel matrix defined by the function handle KERNEL on
%   TRAIN and other input data.

% Author: Paolo D'Apice

mapping = @(a,b) [ (1:size(b,1))', kernel(b,a) ];

traink = mapping(train, train);
for i = 1:length(varargin)
    varargout{i} = mapping(train, varargin{i}); %#ok<AGROW>
end
