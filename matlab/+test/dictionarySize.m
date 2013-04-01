function results = dictionarySize(classname, sizes, dirs, N)
% DICTIONARYSIZE  Test2: dictionary size

% Author: Paolo D'Apice

% for each dictionary size:
%   load dataset
%   run classification

numSz = numel(sizes);
results = cell(numSz, 1);
for i = 1:numSz
    fprintf('Testing dictionary size %d for class "%s"\n', sizes(i), classname);
    datasets = test.loadDatasets(classname, char(dirs{i}), N);
    results{i} = test.runClassification(classname, datasets, N);
end
