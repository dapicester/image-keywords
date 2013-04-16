function results = doTest(classes, class, dirs, N)
% DOTEST  Execute tests for the given class.
%   RESULTS = TEST.DOTEST(CLASSES, CLASS, DIRS, N)  Run N times the
%   classification test for CLASS included in CLASSES using data in DIRS.

% Author: Paolo D'Apice

len = numel(dirs);
results = cell(len, 1);
for i = 1:len
    dir = char(dirs{i});
    fprintf('Running test for "%s" with data in "%s"\n', class, dir);
    datasets = test.loadDatasets(classes, class, dir, N);
    results{i} = test.runClassification(class, datasets, N);
    fprintf('---------------------------------------------------------\n');
end
