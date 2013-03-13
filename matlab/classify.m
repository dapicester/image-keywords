function results = classify(train, test, kernel, varargin)
% CLASSIFY  Train and test a classifier.
%   RESULTS = CLASSIFY(TRAIN, TEST, KERNEL) Run the classification
%   algorithm on the given data on the given TRAIN and TEST data using
%   the function handler KERNEL as kernel function for SVM. 
%   RESULTS is a structure with fields accuracy, precision, recall and
%   f-score.
%
%   The function accepts the following options:
%
%   TrainRank:: [false]
%     Display the ranked list of a subset of the train images.
%
%   TestRank:: [false]
%     Display the ranked list of a subset of the test images.
%
%   TrainPC:: [false]
%     Display the train Precision-Recall curve.
%
%   TestPC:: [false]
%     Display the test Precision-Recall curve.
%
%   TrainStats:: [false]
%     Display statistics on classification results for train images.
%
%   See also: STATS()

% Author: Paolo D'Apice

opts.trainRank  = false;
opts.trainPC    = false;
opts.trainStats = false;
opts.testRank   = false;
opts.testPC     = false;
opts = vl_argparse(opts, varargin);

%% Train a classifier

[train.khistograms, test.khistograms] = precomputeKernel(kernel, train.histograms, test.histograms);
model = trainOneSVM(train.labels, train.khistograms);

% evaluate on training data
[predictedLabels, ~, scores] = predictSVM(train.labels, train.khistograms, model);

% visualize the ranked list of images
if opts.trainRank
    figure(1), clf, set(1, 'name', 'Ranked training images (subset)');
    displayRankedImageList(class, train.names, scores(1:length(train.names)));
end

% visualize the precision-recall curve
if opts.trainPC
    figure(2), clf, set(2, 'name', 'Precision-recall on train data');
    vl_pr(train.labels, scores);
end

% stats on results
if opts.trainStats
    [~, ~, info] = vl_pr(train.labels, scores);
    fprintf('Train AP: %.2f\n', info.auc);

    fprintf(' === Training results ===\n');
    stats(predictedLabels, train.labels);
end

%% Classify test images and assess performance

[predictedLabels, ~, scores] = predictSVM(test.labels, test.khistograms, model);

% visualize the ranked list of images
if opts.testRank
    figure(3), clf, set(3, 'name', 'Ranked testing images (subset)');
    displayRankedImageList(class, test.names, scores(1:length(test.names)));
end

% visualize the precision-recall curve
if opts.testPC
    figure(4), clf, set(4, 'name', 'Precision-recall on test data');
    vl_pr(test.labels, scores);
end

% stats on results
[~, ~, info] = vl_pr(test.labels, scores);
fprintf('Test AP: %.2f\n', info.auc);

results = stats(predictedLabels, test.labels);

%fprintf('\nConfusion matrix:\n'),
%disp(confusionmat(test.labels, predictedLabels, 'order', [1 -1])')

[~, perm] = sort(scores, 'descend');
topK = 36;
fprintf('Correctly retrieved in the top %d: %d\n\n', topK, sum(test.labels(perm(1:topK)) > 0));
