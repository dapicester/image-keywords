function model = trainSVC(labels, data, varargin)
% TRAINSVC  Train a C-SVC using LIBSVM with precomputed kernels.
%   Default options are '-s 0 -t 4', any specified option will be appended.
%
%   MODEL = SVM.TRAINSVC(LABELS, DATA)
%   MODEL = SVM.TRAINSVC(..., 'libsvm options')
%
% See also SVMTRAIN() in LIBSVM.

% Author: Paolo D'Apice

options = '-s 0 -t 4 ';

if nargin == 3
    options = [options varargin{1}];
end

model = svmtrain(labels, data, options);
