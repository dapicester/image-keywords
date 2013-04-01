function results = pyramid(classname, dirs, N)
% PYRAMID  Test 3: pyramidal representation

% Author: Paolo D'Apice

numTiles = numel(dirs);
results = cell(numTiles, 1);
for i = 1:numTiles
    fprintf('Testing tiles(%d) for class "%s"\n', i, classname);
    datasets = test.loadDatasets(classname, char(dirs{i}), N);
    results{i} = test.runClassification(classname, datasets, N);
end

