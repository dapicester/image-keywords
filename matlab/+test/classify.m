function results = classify(train, test, varargin)
% CLASSIFY  Train and test a classifier with LIBSVM.
%
%   RESULTS = TEST.CLASSIFY(TRAIN, TEST)  One-class SVM and linear kernel.
%   RESULTS = TEST.CLASSIFY(..., @KERNEL) One-class SVM and custom kernel.

% Author: Paolo D'Apice

opts.kernel = [];
opts = vl_argparse(opts, varargin);

if isempty(opts.kernel);
    % linear kernel
    model = svmtrain(train.labels, train.histograms, '-q -s 2 -t 0');
    predictedLabels = svmpredict(test.labels, test.histograms, model, '-q');
else
    % custom kernel
    [train2, test2] = svm.precomputeKernel(opts.kernel, ...
                                    train.histograms, test.histograms);
    model = svmtrain(train.labels, train2, '-q -s 2 -t 4');
    predictedLabels = svmpredict(test.labels, test2, model, '-q');
end
results = stats(predictedLabels, test.labels);
