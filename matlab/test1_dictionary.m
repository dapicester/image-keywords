% TEST1_DICTIONARY  Test dictionary for PHOW.
%
%   Objective: check wheter a global dictionary built on all the classes is
%   more powerful than a dictionary built for each class.

clc, clear all
setup

% image classes
classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
numClasses = numel(classes);

% save data dir
testDir = fullfile(DATA_DIR, 'test1');
dirA = fullfile(testDir, 'a');
dirB = fullfile(testDir, 'b');

% number of executions
N = 10;

%% a. precompute per-class dictionary and histograms

for class = classes
    classname = char(class);
    vocabulary = buildVocabulary(classname, ...
                                 'saveDir', dirA);
    buildHistograms(classname, vocabulary, ...
                    'descriptors', 'phow', ...
                    'saveDir', dirA);
    buildHistograms(classname, vocabulary, ...
                    'descriptors', 'phow', ...
                    'reject', true, ...
                    'saveDir', dirA);
end
clear class classname vocabulary

%% b. precompute global dictionary and histograms

vocabulary = buildVocabulary(classes, 'saveDir', dirB);
for class = classes
    classname = char(class);
    buildHistograms(classname, vocabulary, ...
                    'descriptors', 'phow', ...
                    'saveDir', dirB);
    buildHistograms(classname, vocabulary, ...
                    'descriptors', 'phow', ...
                    'reject', true, ...
                    'saveDir', dirB);
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
    resultsA = cell(1, numClasses);
    resultsB = cell(1, numClasses);
    parfor i = 1:numClasses
        classname = char(classes{i});
        [resultsA{i}, resultsB{i}] = test.dictionary(classname, dirA, dirB, N);
    end
    save(resultsFile, 'resultsA', 'resultsB')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

% per-class results
figure(1)    
fscores = zeros(numClasses, 2); 
ferr = zeros(numClasses, 2);
for i = 1:numClasses
    avg = [ struct2array(resultsA{i}.mean); ...
            struct2array(resultsB{i}.mean) ]';
    error = [ struct2array(resultsA{i}.std); ...
              struct2array(resultsB{i}.std) ]';
    fscores(i,:) = avg(4,:);
    ferr(i,:) = error(4,:);
    
    subplot(2, 3, i)
    test.bar(avg, error);
    ylim([0 1])
    title(char(classes{i}), 'Interpreter', 'none')
    legend('per-class dictionary', 'global dictionary')
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test1-all.eps'), '-depsc2', '-f1')

% only f-score
figure(2)
test.bar(fscores, ferr);
ylim([0 1])
title('F-score')
legend('per-class dictionary', 'global dictionary')
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test1-fscore.eps'), '-depsc2', '-f2')

clear i class classname data
