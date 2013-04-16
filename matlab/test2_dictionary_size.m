% TEST2_DICTIONARY_SIZE  Test dictionary size for PHOW.
%
%   Objective: check how the dictionary size affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% dictionary sizes
dictionarySize = [ 200 300 500 800 1000 2000 ];
numDictionaries = numel(dictionarySize);

% save data dirs
testDir = fullfile(DATA_DIR, 'test2');
dirs = cell(numDictionaries, 1);
for i = 1:numDictionaries
    dirs{i} = fullfile(testDir, num2str(dictionarySize(i)));
    mkdir(dirs{i});
end

% number of executions
N = 10;

%% compute dictionaries and histograms

for i = 1:numDictionaries
    dir = char(dirs{i});
    vocabulary = buildVocabulary(classes, ...
                                 'numWords', dictionarySize(i), ...
                                 'saveDir', dir);
    buildHistograms(allClasses, vocabulary, ...
                    'descriptors', 'phow', ...
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

legend = arrayfun(@(s) sprintf('%d words', s), dictionarySize, 'UniformOutput', false);
              
test.plotResults(results, classes, numDictionaries, ...
                 'legend', legend, ...
                 'legendPosition', 'NorthWest', ...
                 'saveDir', testDir);

clear legend