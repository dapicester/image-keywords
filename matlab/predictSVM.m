function [predicted_labels, accuracy, scores] = predictSVM(labels, data, model)
% PREDICTSVM  Make predictions using LIBSVM.
%
% Author: Paolo D'Apice

options = '-q';
[predicted_labels, accuracy, scores] = svmpredict(labels, data, model, options);
