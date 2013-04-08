function best = model(classname, kernel, dir, N)
% MODEL  Test for SVM parameters.

% Author: Paolo D'Apice

datasets = test.loadDatasets(classname, dir, N);
params = cell(N, 1);
for i = 1:N
    fprintf('Model selection for class "%s" (%d/%d)\n', classname, i, N)
    params{i} = svm.gridOneSVM(datasets.train(i).labels, ...
                               datasets.train(i).histograms, ...
                               kernel);
end

params = struct2dataset(cell2mat(params));
[~,idx] = min(params.bestobj);
best = dataset2struct(params(idx,:));
