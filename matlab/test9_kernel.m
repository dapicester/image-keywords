% TEST9_KERNEL  Test SVM kernel.
%
%   Objective: find the best kernel mapping for the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes
%classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
classes = { 'bag', 'shoes' };
numClasses = numel(classes);

% kernels
import kernel.*
kernels = { @linear, @rbf, @chi2, @histint, @hellinger }; % TODO parameters
numKernels = numel(kernels);

% save data dirs
testDir = fullfile(DATA_DIR, 'test9');

% number of executions
N = 10;

%% precompute histograms

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
fscores = zeros(numClasses, numKernels);
ferr = zeros(numClasses, numKernels);
for i = 1:numClasses
    classname = char(classes{i});
    data = zeros(4, numKernels);
    err = zeros(4, numKernels);
    for j = 1:numKernels
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j) = struct2array(results{i}{j}.std);
        fscores(i,j) = data(4,j);
        ferr(i,j) = err(4,j);
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
test.bar(fscores,ferr);
ylim([0 1])
title('F-score')
legend(strrep(cellfun(@(f) func2str(f), kernels, 'UniformOutput', false), 'kernel.', ''))
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test9-fscore.eps'), '-depsc2', '-f2')

clear i j class classname data
