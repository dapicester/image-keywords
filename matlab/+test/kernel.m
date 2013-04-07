function results = kernel(classname, dir, kernels, N)
% KERNEL  Test for different kernels.

% Author: Paolo D'Apice

len = numel(kernels);
results = cell(len, 1);
for i = 1:len
    kernel = kernels{i};
    fprintf('Running test for class "%s" and %s\n', ...
            classname, func2str(kernel));
    datasets = test.loadDatasets(classname, dir, N);
    results{i} = test.runClassification(classname, datasets, N, ...
                                        'kernel', kernel);
end
