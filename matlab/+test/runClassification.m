function results = runClassification(classname, datasets, N)
% RUNCLASSIFICATION  Run N classifications for target class.
%
%   RESULTS = TEST.RUNCLASSIFICATION(CLASSNAME, DATASETS, N)  Run N times the
%   classification on the given DATASETS.
%   RESULTS is a structurs with fields 'samples', 'mean', 'std' containing
%   respectively the classification results, the average and standard
%   deviation.

% Author: Paolo D'Apice

res = cell(N, 1);
for i = 1:N
    % classify
    fprintf('Classifying images in class "%s" (%d/%d)\n', classname, i, N)
    res{i} = test.classify(datasets.train(i), datasets.val(i));
end
results.samples = struct2dataset(cell2mat(res));
[results.mean, results.std] = test.getResults(results.samples);
