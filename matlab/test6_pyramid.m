% TEST6_PYRAMID  Test pyramid representation for PHOG.
%
%   Objective: check how the pyramid representation affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% pyramid levels
levels = 0:3;
numLevels = numel(levels);

% save data dirs
testDir = fullfile(DATA_DIR, 'test6');
dirs = cell(numLevels, 1);
for i = 1:numLevels
    dirs{i} = fullfile(testDir, num2str(levels(i)));
    mkdir(dirs{i});
end

% number of executions
N = 10;

%% precompute histograms

for i = 1:numLevels
    buildHistograms(allClasses, {}, ...
                    'descriptors', 'phog', ...
                    'levels', levels(i), ...
                    'saveDir', dirs{i});
end
clear i

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

legend = arrayfun(@(l) sprintf('Level %d', l), levels, 'UniformOutput', false);
test.plotResults(results, classes, numLevels, ...
                 'legend', legend, ...
                 'legendPosition', 'NorthWest', ...
                 'saveDir', testDir);
clear legend