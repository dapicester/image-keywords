function results = siftParams(classname, dirs, N)
% SIFTPARAMS  Test4: SIFT parameters scale and step size

% Author: Paolo D'Apice

numParams = numel(dirs);
results = cell(numParams, 1);
for i = 1:numParams
    fprintf('Testing params(%d) for class "%s"\n', i, classname);
    datasets = test.loadDatasets(classname, char(dirs{i}), N);
    results{i} = test.runClassification(classname, datasets, N);    
end
