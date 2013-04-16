% TEST9_KERNEL  Test SVM kernel.
%
%   Objective: find the best kernel mapping for the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% kernels TODO parameters
kernels = { @kernel.linear, ...
            @kernel.rbf, ...
            @kernel.chi2, ...
            @kernel.histint, ...
            @kernel.hellinger }; 
numKernels = numel(kernels);

% save data dirs
testDir = fullfile(DATA_DIR, 'test9');
mkdir(testDir);

% number of executions
N = 10;

%% precompute histograms 

% FIXME per-class configuration!

for class = classes
    classname = char(class);
    buildHistograms(classname, {}, ...
                    'descriptors', 'phog', ...
                    'levels', 1);
    buildHistograms(classname, {}, ...
                    'descriptors', 'phog', ...
                    'levels', 1, ...
                    'reject', true);
end
clear class classname

%% do test

resultsFile = fullfile(testDir, 'results.mat');

if exist(resultsFile, 'file')
    % load results from file
    load(resultsFile);
    fprintf('Results loaded from file %s\n', resultsFile)
else
    % run test
    results = cell(1, numClasses);
    parfor i = 1:numClasses
       classname = char(classes{i});
       results{i} = test.kernel(classname, DATA_DIR, kernels, N);
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

% per-class results
figure(1)
precision = zeros(numClasses, numKernels);
precisionError = zeros(numClasses, numKernels);
for i = 1:numClasses
    classname = char(classes{i});
    data = zeros(4, numKernels);
    err = zeros(4, numKernels);
    for j = 1:numKernels
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j) = struct2array(results{i}{j}.std);
        precision(i,j) = data(2,j);
        precisionError(i,j) = err(2,j);
    end
    subplot(2,3,i)
    test.bar(data,err);
    ylim([0 1])
    title(classname, 'Interpreter', 'none')
    legend(strrep(cellfun(@(f) func2str(f), kernels, 'UniformOutput', false), 'kernel.', ''))
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test9-all.eps'), '-depsc2', '-f1')

% global
figure(2)
test.bar(precision,precisionError);
ylim([0 1])
title('Precision')
legend(strrep(cellfun(@(f) func2str(f), kernels, 'UniformOutput', false), 'kernel.', ''))
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test9-precision.eps'), '-depsc2', '-f2')

clear i j class classname data
