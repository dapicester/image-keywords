% TEST7_DESCRIPTORS  Test PHOW, PHOG and their combination.
%
%   Objective: check if the combination of descriptor is more effective
%   than a single descriptor.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes
%classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
classes = { 'bag', 'shoes' };
numClasses = numel(classes);

% descriptors
descriptors = { 'phow', 'phog', 'both' };
numDescriptors = numel(descriptors);

% save data dirs
testDir = fullfile(DATA_DIR, 'test7');
dirs = cell(numDescriptors, 1);
for i = 1:numDescriptors
    dirs{i} = fullfile(testDir, char(descriptors{i}));
end

% number of executions
N = 10;

%% precompute histograms

vocabulary = buildVocabulary(classes, 'saveDir', testDir);
for i = 1:numDescriptors
    dir = dirs{i};
    descr = char(descriptors{i});
    for class = classes
        classname = char(class);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', descr, ...
                        'levels', 1, ...
                        'saveDir', dir);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', descr, ...
                        'levels', 1, ...
                        'reject', true, ...
                        'saveDir', dir);
    end
end
clear i dir class classname vocabulary

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
       results{i} = test.doTest(classname, dirs, N);
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

% per-class results
figure(1)
precision = zeros(numClasses, numDescriptors);
precisionError = zeros(numClasses, numDescriptors);
for i = 1:numClasses
    classname = char(classes{i});
    data = zeros(4, numDescriptors);
    err = zeros(4, numDescriptors);
    for j = 1:numDescriptors
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j) = struct2array(results{i}{j}.std);
        precision(i,j) = data(2,j);
        precisionError(i,j) = err(2,j);
    end
    subplot(2,3,i)
    test.bar(data,err);
    ylim([0 1])
    title(classname, 'Interpreter', 'none')
    legend(upper(descriptors))
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test7-all.eps'), '-depsc2', '-f1')

% global
figure(2)
test.bar(precision,precisionError);
ylim([0 1])
title('Precision')
legend(upper(descriptors))
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test7-precision.eps'), '-depsc2', '-f2')

clear i j class classname data
