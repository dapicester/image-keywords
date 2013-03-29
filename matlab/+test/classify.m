function results = classify(train, test)
% CLASSIFY  Train and test a classifier with LIBSVM.

% Author: Paolo D'Apice

libsvm_opts =  '-q -s 2 -t 0';
model = svmtrain(train.labels, train.histograms, libsvm_opts);
predictedLabels = svmpredict(test.labels, test.histograms, model, '-q');

results = stats(predictedLabels, test.labels);
