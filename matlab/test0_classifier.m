% TEST0_CLASSIFIER  Test SVM type.
%
%   Objective: verify the effectiveness of a 1-SVM wrt C-SVC.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% save data dir
testDir = fullfile(DATA_DIR, 'test0');
mkdir(testDir);

% number of executions
N = 10;

%% precompute histograms

vocabulary = buildVocabulary(classes, 'saveDir', testDir);
for class = allClasses
    classname = char(class);
    buildHistograms(classname, vocabulary, ...
                    'saveDir', testDir);
    buildHistograms(classname, vocabulary, ...
                    'reject', true, ...
                    'saveDir', testDir);
end
clear class classname vocabulary

%% do test

resultsFile = fullfile(testDir, 'results.mat');

if exist(resultsFile, 'file')
    % load results from file
    load(resultsFile);
    fprintf('Results loaded from file %s\n', resultsFile)
else
    results = cell(1, numClasses);
    parfor i = 1:numClasses
        classname = char(classes{i});
        results{i} = test.svm(allClasses, classname, testDir, N);
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

legend = { 'one-class SVM', 'multi-class SVM' };

test.plotResults(results, classes, 2, ...
                 'legend', legend, ...
                 'saveDir', testDir);