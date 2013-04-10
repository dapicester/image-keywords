function results = classify(train, test, kernel, varargin)
% CLASSIFY  Train and test a classifier.
%
%   RESULTS = CLASSIFY(TRAIN, TEST, KERNEL) Run the classification
%   algorithm on the given TRAIN and TEST data using the function handler 
%   KERNEL as kernel function for SVM.
%   RESULTS is a structure with fields accuracy, precision, recall and
%   f-score.
%
%   The function accepts the following options:
%
%   Verbose:: [false]
%     Print verbose messages.
%
%   TrainRank:: [false]
%     Display the ranked list of a subset of the train images.
%
%   TestRank:: [false]
%     Display the ranked list of a subset of the test images.
%
%   ShowPC:: [false]
%     Display the test Precision-Recall curve.

% Author: Paolo D'Apice

opts.nu = [];
opts.verbose    = false;
opts.trainRank  = false;
opts.testRank   = false;
opts.showPC     = false;
opts = vl_argparse(opts, varargin);

if opts.verbose, print = @fprintf; else print = @nop; end

%% Train a classifier

[train.khistograms, test.khistograms] = svm.precomputeKernel(kernel, ...
                                        train.histograms, test.histograms);
options = tif(~isempty(opts.nu), sprintf('-q -n %g', opts.nu), '-q');
model = svm.trainOneSVM(train.labels, train.khistograms, options);

if opts.trainRank
    [~,~,scores] = svm.predict(train.labels, train.khistograms, model, '-q');
    displayRankedImageList(1, train.names, scores, 'title', 'train data');
end

%% Classify test images and assess performance

[predictedLabels, ~, scores] = svm.predict(test.labels, test.khistograms, model, '-q');

if opts.testRank,
    displayRankedImageList(2, test.names, scores, 'title', 'test data');
end

if opts.showPC,
    plot_pr(3, 'test data', test.labels, scores);
end

% stats on results
[~,~,info] = vl_pr(test.labels, scores);
print('Test AP: %.2f %%\n', info.auc*100);

results = stats(predictedLabels, test.labels);


function nop(varargin)
% NOP  Does nothing.


function plot_pr(handler, title, labels, scores)
% PLOT_PR  Plot the precision-recall curve.
figure(handler); clf;
set(handler, 'name', sprintf('Precision-recall: %s', title));
vl_pr(labels, scores);
