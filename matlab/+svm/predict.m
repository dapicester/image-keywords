function [predictions, accuracy, scores] = predict(labels, data, model, varargin)
% PREDICT  Make predictions using LIBSVM.
%
%   [PREDICTIONS, ACCURACY, SCORES] = SVM.PREDICT(LABELS, DATA, MODEL)
%   [PREDICTIONS, ACCURACY, SCORES] = SVM.PREDICT(..., 'libsvm options')
%
% See also SVMPREDICT() in LIBSVM.

% Author: Paolo D'Apice

options = '';
if nargin == 4
    options = varargin{1};
end

[predictions, accuracy, scores] = svmpredict(labels, data, model, options);
