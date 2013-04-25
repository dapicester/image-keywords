function results = svm(classes, class, dir, N)
% SVM  Test different SVM classifiers.

% Author: Paolo D'Apice

% 1-svm
datasets = test.loadDatasets(classes, class, dir, N);
results{1} = test.runClassification(class, datasets, N);

% c-svc
datasets = test.loadDatasets(classes, class, dir, N, 'classifier', 'multi');
results{2} = test.runClassification(class, datasets, N, 'classifier', 'multi');
