function model = trainOneSVM(labels, data, varargin)
% TRAINONESVM  Train a one-class SVM using LIBSVM with precomputed kernels.
%   Default options are '-s 2 -t 4', any specified option will be appended.
%
%   MODEL = SVM.TRAINONESVM(LABELS, DATA)
%   MODEL = SVM.TRAINONESVM(..., 'libsvm options')
%
% See also SVMTRAIN() in LIBSVM.

% Author: Paolo D'Apice

options = '-s 2 -t 4 ';

if nargin == 3
    options = [options varargin{1}];
end

model = svmtrain(labels, data, options);
