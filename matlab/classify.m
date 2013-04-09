function results = classify(train, test, kernel, varargin)
% CLASSIFY  Train and test a classifier.
%
%   RESULTS = CLASSIFY(TRAIN, TEST, KERNEL) Run the classification
%   algorithm on the given data on the given TRAIN and TEST data using
%   the function handler KERNEL as kernel function for SVM. 
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
if ~isempty(opts.nu)
    options = sprintf('-q -n %g', opts.nu);
else 
    options = '-q';
end
model = svm.trainOneSVM(train.labels, train.khistograms, options);

% evaluate on training data
[~,~,scores] = svm.predict(train.labels, train.khistograms, model, '-q');

% visualize the ranked list of images
if opts.trainRank, display_ranked(1, 'train data', train.names, scores); end

%% Classify test images and assess performance

[predictedLabels, ~, scores] = svm.predict(test.labels, test.khistograms, model, '-q');

% visualize the ranked list of images
if opts.testRank, display_ranked(3, 'test data', test.names, scores); end

% visualize the precision-recall curve
if opts.showPC, plot_pr(4, 'test data', test.labels, scores); end

% stats on results
[~, ~, info] = vl_pr(test.labels, scores);
print('Test AP: %.2f\n', info.auc);

results = stats(predictedLabels, test.labels);

[~, perm] = sort(scores, 'descend');
topK = 36;
print('Correctly retrieved in the top %d: %d\n\n', topK, sum(test.labels(perm(1:topK)) > 0));


function nop(varargin)
% NOP  Does nothing.


function plot_pr(handler, title, labels, scores)
% PLOT_PR  Plot the precision-recall curve.
figure(handler); clf;
set(handler, 'name', sprintf('Precision-recall: %s', title));
vl_pr(labels, scores);


function display_ranked(handler, title, names, scores)
% DISPLAY_RANKED  Display ranked images.
figure(handler); clf;
set(handler, 'name', sprintf('Ranked images (subset): %s', title));
displayRankedImageList(names, scores);
