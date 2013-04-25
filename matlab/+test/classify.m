function results = classify(train, test, varargin)
% CLASSIFY  Train and test a classifier with LIBSVM.
%
%   RESULTS = TEST.CLASSIFY(TRAIN, TEST)  One-class SVM and linear kernel.
%   RESULTS = TEST.CLASSIFY(..., @KERNEL) One-class SVM and custom kernel.

% Author: Paolo D'Apice

opts.classifier = 'single';
opts.kernel = [];
opts = vl_argparse(opts, varargin);

libsvmopt = '-q';
switch opts.classifier
    case 'single'
        libsvmopt = [libsvmopt ' -s 2'];
    case 'multi'
        libsvmopt = [libsvmopt ' -s 0'];
end

if isempty(opts.kernel);
    % linear kernel
    model = svmtrain(train.labels, train.histograms, [libsvmopt ' -t 0']);
    predictedLabels = svmpredict(test.labels, test.histograms, model, '-q');
else
    % custom kernel
    [train2, test2] = svm.precomputeKernel(opts.kernel, ...
                                    train.histograms, test.histograms);
    model = svmtrain(train.labels, train2, [libsvmopt ' -t 4']);
    predictedLabels = svmpredict(test.labels, test2, model, '-q');
end
results = stats(predictedLabels, test.labels);
