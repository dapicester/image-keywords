% TEST2_DICTIONARY_SIZE  Test dictionary size for PHOW.
%
%   Objective: check how the dictionary size affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes
classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
numClasses = numel(classes);

% dictionary sizes
dictionarySize = [ 200 300 500 800 1000 2000 ];
numDictionaries = numel(dictionarySize);

% save data dirs
testDir = fullfile(DATA_DIR, 'test2');
dirs = cell(numDictionaries, 1);
for i = 1:numDictionaries
    dirs{i} = fullfile(testDir, num2str(dictionarySize(i)));
end

% number of executions
N = 10;

%% precompute dictionaries and histograms

for i = 1:numDictionaries
    dir = char(dirs{i});
    vocabulary = buildVocabulary(classes, ...
                                 'numWords', dictionarySize(i), ...
                                 'saveDir', dir);
    for class = classes
        classname = char(class);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', 'phow', ...
                        'saveDir', dir);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', 'phow', ...
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
fscores = zeros(numClasses, numDictionaries);
ferr = zeros(numClasses, numDictionaries);
for i = 1:numClasses
    data = zeros(4, numDictionaries);
    err = zeros(4, numDictionaries);
    for j = 1:numDictionaries
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j)  = struct2array(results{i}{j}.std);
        fscores(i,j) = data(4,j); 
        ferr(i,j) = err(4,j);
    end
    
    subplot(2,3,i)
    test.bar(data, err);
    ylim([0 1])
    title(char(classes{i}), 'Interpreter', 'none')
    legend({num2str(dictionarySize')})
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test2-all.eps'), '-depsc2', '-f1')

% only f-score

figure(2)
test.bar(fscores, ferr);
ylim([0 1])
title('F-score')
legend({num2str(dictionarySize')})
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test2-fscore.eps'), '-depsc2', '-f2')

clear i j class classname data
