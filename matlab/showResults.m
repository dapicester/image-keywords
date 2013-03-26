function average = showResults(classname, results, varargin)
% SHOWRESULTS  Show classification results.
%
%  AVERAGE = SHOWRESULTS(CLASSNAME, RESULTS)  Computes the average
%  classification results for class CLASSNAME. RESULTS is a dataset Kx4
%  where each row contains classification result samples as returned by the
%  function CLASSIFY.
%
%  The function accepts the following options:
%
%  Summary:: [true]
%    Print a text summary.
%
%  See also: CLASSIFY()

% Author: Paolo D'Apice

opts.summary = true;
opts = vl_argparse(opts, varargin);

% TODO: graph and plots here.

average.accuracy = mean(results.accuracy);
average.precision = mean(results.precision);
average.recall = mean(results.recall);
average.fscore = mean(results.fscore);

if opts.summary
    fprintf('----------------------------\n')
    fprintf(' Class %s\n', classname)
    fprintf('----------------------------\n')
    fprintf('  Average accuracy : %f\n', average.accuracy)
    fprintf('  Average precision: %f\n', average.precision)
    fprintf('  Average recall   : %f\n', average.recall)
    fprintf('  Average f-score  : %f\n', average.fscore)
    fprintf('----------------------------\n')
end
