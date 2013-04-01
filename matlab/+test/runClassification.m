function results = runClassification(classname, datasets, N)
% RUNCLASSIFICATION  Run N classifications for target class.

% Author: Paolo D'Apice

results = cell(N, 1);
for i = 1:N
    % classify
    fprintf('Classifying images in class "%s" (%d/%d)\n', classname, i, N)
    results{i} = test.classify(datasets.train(i), datasets.val(i));
end
results = struct2dataset(cell2mat(results));
results = showResults(classname, results, 'summary', false);
