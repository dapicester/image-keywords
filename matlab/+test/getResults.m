function [m, e] = getResults(results)
% GETRESULTS  Get average and standard deviation of classification results.

% Author: Paolo D'Apice

m.accuracy  = mean(results.accuracy);
m.precision = mean(results.precision);
m.recall    = mean(results.recall);
m.fscore    = mean(results.fscore);

e.accuracy  = std(results.accuracy);
e.precision = std(results.precision);
e.recall    = std(results.recall);
e.fscore    = std(results.fscore);
