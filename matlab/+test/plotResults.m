function plotResults(results, classes, numTests, varargin)
% PLOTRESULTS  Plot test results.

% Author: Paolo D'Apice

conf.legend = [];
conf.li = 'tex';
conf.saveDir = [];
conf = vl_argparse(conf, varargin);

numClasses = numel(classes);
precision = zeros(numClasses, numTests); 
precisionError = zeros(numClasses, numTests);

% all results
figure(1)
for i = 1:numClasses
    data = zeros(4, numTests);
    err = zeros(4, numTests);
    for j = 1:numTests
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j)  = struct2array(results{i}{j}.std);
        precision(i,j) = data(2,j);
        precisionError(i,j) = err(2,j);
    end
    
    subplot(1, 3, i)
    test.bar(data, err);
    ylim([0 1])
    title(char(classes{i}), 'Interpreter', 'none')
    % TODO global legend
    if ~isempty(conf.legend)
        legend(conf.legend, 'Interpreter', conf.li);
    end
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')

% only precision
figure(2)
test.bar(precision, precisionError);
ylim([0 1])
title('Precision')
% TODO global legend
if ~isempty(conf.legend)
    legend(conf.legend, 'Interpreter', conf.li)
end
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')

% save
if ~isempty(conf.saveDir)
    file1 = fullfile(conf.saveDir, 'results-all.eps');
    print(file1, '-depsc2', '-f1')
    fprintf('Figure 1 saved to file %s\n', file1);
    
    file2 = fullfile(conf.saveDir, 'results-precision.eps');
    print(file2, '-depsc2', '-f2')
    fprintf('Figure 2 saved to file %s\n', file2);
end

