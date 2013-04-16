% TEST4_SIFT  Test SIFT parameters
%
%   Objective: check how the SIFT parameters affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% SIFT parameters {step, scales}
params = { {  4, [4 6  8 10] }, ...
           {  4, [4 8 12 16] }, ...
           { 10, [4 6  8 16] }, ...
           { 10, [4 8 12 16] } };
numParams = numel(params);

% save data dirs
testDir = fullfile(DATA_DIR, 'test4');
dirs = cell(numParams, 1);
for i = 1:numParams
    dirs{i} = fullfile(testDir, num2str(i));
    mkdir(dirs{i});
end

% number of executions
N = 10;

%% precompute histograms

for i = 1:numParams
    dir = dirs{i};
    vocabulary = buildVocabulary(classes, ...
                                 'step', params{i}{1}, ...
                                 'scales', params{i}{2}, ...
                                 'saveDir', dir);
    buildHistograms(allClasses, vocabulary, ...
                    'descriptors', 'phow', ...
                    'step', params{i}{1}, ...
                    'scales', params{i}{2}, ...
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
       results{i} = test.doTest(classes, classname, dirs, N); %#ok<*PFBNS>
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

legend = cellfun(@(x) sprintf('s = %d \\sigma = %s\n', x{1}, mat2str(x{2})), ...
                 params, 'UniformOutput', false);

test.plotResults(results, classes, numParams, ...
                 'legend', legend, ...
                 'legendPosition', 'NorthWest', ...
                 'saveDir', testDir);

clear legend