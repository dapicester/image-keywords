function results = doTest(classname, dirs, N)
% DOTEST  Execute tests for the given class.

% Author: Paolo D'Apice

len = numel(dirs);
results = cell(len, 1);
for i = 1:len
    dir = char(dirs{i});
    fprintf('Running test for class "%s" using data in "%s"\n', ...
            classname, dir);
    datasets = test.loadDatasets(classname, dir, N);
    results{i} = test.runClassification(classname, datasets, N);    
end
