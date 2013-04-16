% TEST7_DESCRIPTORS  Test PHOW, PHOG and their combination.
%
%   Objective: check if the combination of descriptor is more effective
%   than a single descriptor.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% descriptors
descriptors = { 'phow', 'phog', 'both' };
numDescriptors = numel(descriptors);

% save data dirs
testDir = fullfile(DATA_DIR, 'test7');
dirs = cell(numDescriptors, 1);
for i = 1:numDescriptors
    dirs{i} = fullfile(testDir, char(descriptors{i}));
    mkdir(dirs{i});
end

% number of executions
N = 10;

%% precompute histograms

vocabulary = buildVocabulary(classes, 'saveDir', testDir);
for i = 1:numDescriptors
    dir = dirs{i};
    descr = char(descriptors{i});
    buildHistograms(allClasses, vocabulary, ...
                    'descriptors', descr, ...
                    'levels', 1, ...
                    'saveDir', dir);
end
clear i dir vocabulary

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
       results{i} = test.doTest(classes, classname, dirs, N); %#ok<PFBNS>
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

test.plotResults(results, classes, numDescriptors, ...
                 'legend', {'PHOW','PHOG','PHOG and PHOW'}, ...
                 'saveDir', testDir);
