function [predictions, accuracy, scores] = predictSVM(labels, data, model, varargin)
% PREDICTSVM  Make predictions using LIBSVM.
%
%   [PREDICTIONS, ACCURACY, SCORES] = PREDICTSVM(LABELS, DATA, MODEL)
%   [PREDICTIONS, ACCURACY, SCORES] = PREDICTSVM(..., 'libsvm options')
%
% See also SVMPREDICT() in LIBSVM.

% Author: Paolo D'Apice

options = '';
if nargin == 4
    options = varargin{1};
end

[predictions, accuracy, scores] = svmpredict(labels, data, model, options);
