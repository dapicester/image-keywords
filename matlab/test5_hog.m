% TEST5_HOG  Test HOG parameters
%
%   Objective: check how the HOG parameters affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% HOG parameters {range, angles}
params = { { 180  4 } { 360  8 } ...
           { 180  8 } { 360 16 } ...
           { 180 16 } { 360 32 } ...
           { 180 32 } { 360 64 } };
numParams = numel(params);

% save data dirs
testDir = fullfile(DATA_DIR, 'test5');
dirs = cell(numParams, 1);
for i = 1:numParams
    dirs{i} = fullfile(testDir, num2str(i));
    mkdir(dirs{i});
end

% number of executions
N = 10;

%% precompute histograms

for i = 1:numParams
    buildHistograms(allClasses, {}, ...
                    'descriptors', 'phog', ...
                    'angles', params{i}{1}, ...
                    'bins', params{i}{2}, ...
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

legend = cellfun(@(p) sprintf('\\theta = %d n = %d', p{1}, p{2}), ...
                 params, 'UniformOutput', false);

test.plotResults(results, classes, numParams, ...
                 'legend', legend, ...
                 'legendPosition', 'BestOutside', ...
                 'saveDir', testDir);

clear legend
