% TEST1_DICTIONARY  Test dictionary for PHOW.
%
%   Objective: check wheter a global dictionary built on all the classes is
%   more powerful than a dictionary built for each class.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes (not including 'reject')
classes = { 'bag', 'shoes', 'standing_people' };
numClasses = numel(classes);

allClasses = union(classes, 'reject');

% save data dir
testDir = fullfile(DATA_DIR, 'test1');
dirA = fullfile(testDir, 'a');
dirB = fullfile(testDir, 'b');
dirC = fullfile(testDir, 'c');

mkdir(dirA);
mkdir(dirB);
mkdir(dirC);

% number of executions
N = 10;

%% compute per-class dictionary and histograms

for class = classes
    classname = char(class);
    savedir = fullfile(dirA, classname);
    mkdir(savedir);
    vocabulary = buildVocabulary(classname, ...
                                 'saveDir', savedir);
    buildHistograms(allClasses, vocabulary, ...
                    'descriptors', 'phow', ...
                    'saveDir', savedir);
end
clear class classname savedir vocabulary

%% compute global dictionary and histograms (no reject)

vocabulary = buildVocabulary(classes, ...
                             'saveDir', dirB);
for class = allClasses
    classname = char(class);
    buildHistograms(classname, vocabulary, ...
                    'descriptors', 'phow', ...
                    'saveDir', dirB);
end
clear class classname vocabulary

%% compute global dictionary and histograms (including reject)
 
vocabulary = buildVocabulary(allClasses, ...
                             'saveDir', dirC);
for class = allClasses
    classname = char(class);
    buildHistograms(classname, vocabulary, ...
                    'descriptors', 'phow', ...
                    'saveDir', dirC);
end
clear class classname vocabulary

%% do test

resultsFile = fullfile(testDir, 'results.mat');

if exist(resultsFile, 'file')
    % load results from file
    load(resultsFile);
    fprintf('Results loaded from file %s\n', resultsFile)
else
    % run test
    dirsA = cellfun(@(c)fullfile(dirA,char(c)), classes, 'UniformOutput', false);
    dirs = cat(2, dirsA, dirB, dirC);
    results = cell(1, numClasses);
    parfor i = 1:numClasses
        classname = char(classes{i});
        results{i} = test.doTest(classes, classname, dirs, N); %#ok<PFBNS>
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear dirsA dirs i classname
end

%% compare results

numTests = numClasses + 2; % dirA*numClasses + dirB + dirC

legend = cat(2, cellfun(@(c) sprintf('per-class dictionary (%s)', char(c)), ...
                        classes, 'UniformOutput', false), ...
                'global dictionary (no outliers)', ...
                'global dictionary' );
       
test.plotResults(results, classes, numTests, ...
                 'legend', legend, ...
                 'legendInterpreter', 'none', ...
                 'legendPosition', 'NorthWest', ...
                 'saveDir', testDir);

clear numTests legend
