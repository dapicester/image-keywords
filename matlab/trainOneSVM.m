function model = trainOneSVM(labels, data, varargin)
% TRAINONESVM  Train a one-class SVM using LIBSVM with precomputed kernels.
%   MODEL = TRAINONESVM(LABELS, DATA)
%   MODEL = TRAINONESVM(LABELS, DATA, 'libsvm options')
%
% See also SVMTRAIN()

% Author: Paolo D'Apice

options = '-s 2 -t 4 -q';

if nargin == 3
    options = varargin{1};
end

model = svmtrain(labels, data, options);
