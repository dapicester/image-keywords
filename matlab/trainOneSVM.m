function model = trainOneSVM(varargin)
% TRAINONESVM  Train a one-class SVM using LIBSVM.
%
%   MODEL = TRAINONESVM(DATA)
%   MODEL = TRAINONESVM(LABELS, DATA)
%   MODEL = TRAINONESVM(LABELS, DATA, 'libsvm options')

% Author: Paolo D'Apice

options = '-s 2 -q ';

if nargin == 1
    data = varargin{1};
    labels = ones(size(data, 1), 1);
else
    labels = varargin{1};
    data = varargin{2};
    
    if nargin == 3
        options = [options varargin{3}];
    end 
end

model = svmtrain(labels, data, options);
