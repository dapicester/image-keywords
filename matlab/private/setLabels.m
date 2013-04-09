function labels = setLabels(classname, scores)
% SETLABELS  Assign labels using classification scores.
%
%   Detailed explanation goes here

% Author: Paolo D'Apice

labels = cell(size(scores));
labels(scores > 0) = { classname };
