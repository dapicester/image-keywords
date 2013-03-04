function res = stats(actual, expected, varargin)
% STATS  Compute statistics on classification results.
%
%   RESULTS = STATS(ACTUAL, EXPECTED) Compute statistics and returns a
%   structure containing the fields 'accuracy', 'precision', 'recall' and
%   'fscore'. 
%
%   Use STATS(..., 'plot', true) to plot results.%   
%   Use STATS(..., 'print', true) to print statistics results.

% Author: Paolo D'Apice

opts.plot = false;
opts.print = true;
opts = vl_argparse(opts, varargin);

len = @(in) numel(find(in));

pos_i = find(expected == 1);

num = numel(actual);
acc = len(actual == expected);

true_pos = len(actual(pos_i) == 1);
false_neg = len(actual(pos_i) ~= 1);
pos = len(actual == 1);

res.accuracy = acc / num;
res.precision = true_pos / pos;
res.recall = true_pos / (true_pos + false_neg);
res.fscore = 2 * res.precision * res.recall / (res.precision + res.recall);

if opts.print
    % percentages
    fprintf('  accuracy: %8.4f%%\t(%d/%d)\n', 100 * res.accuracy, acc, num);
    fprintf(' precision: %8.4f%%\t(%d/%d)\n', 100 * res.precision, true_pos, pos);
    fprintf('    recall: %8.4f%%\t(%d/%d)\n', 100 * res.recall, true_pos, true_pos + false_neg);
    fprintf('   f-score: %8.4f%%\n', 100 * res.fscore);
end

if opts.plot
    figure(99), clf
    bar(expected, 'r'), xlim([1 num])
    hold on
    bar(actual)
end
