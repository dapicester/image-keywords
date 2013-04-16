% TEST3_PYRAMID  Test pyramid representation for PHOW.
%
%   Objective: check how the pyramid representation affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% pyramid representations
p1 = [1 1];
p2 = [2 2];
p3 = [3 3];
ps = [3 1];
tiles = { {p1}, {p2}, {p3}, {p1,p2}, {p1,p2,p3}, {p1,p2,ps} };
numTiles = numel(tiles);

% save data dirs
testDir = fullfile(DATA_DIR, 'test3');
dirs = cell(numTiles, 1);
for i = 1:numTiles
    dirs{i} = fullfile(testDir, num2str(i));
    mkdir(dirs{i});
end

% number of executions
N = 10;

%% compute vocabulary and histograms

vocabulary = buildVocabulary(classes, ...
                             'saveDir', testDir);
for i = 1:numTiles
    dir = dirs{i};
    buildHistograms(allClasses, vocabulary, ...
                    'descriptors', 'phow', ...
                    'tiles', tiles{i}, ...
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

legend = cellfun(@(t) sprintf('Tiles %s', t), ...
            { '1\times1', '2\times2', '3\times3', '1\times1 2\times2', ...
              '1\times1 2\times2 3\times3', '1\times1 2\times2 3\times1' }, ...
              'UniformOutput', false);

test.plotResults(results, classes, numTiles, ...
                 'legend', legend, ...
                 'legendPosition', 'NorthWest', ...
                 'saveDir', testDir);

clear legend
