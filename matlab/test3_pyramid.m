% TEST3_PYRAMID  Test pyramid representation for PHOW.
%
%   Objective: check how the pyramid representation affects the classification.

clc, clear all
setup

% image classes
classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
numClasses = numel(classes);

% pyramid representations
p1 = [1 1];     p2 = [2 2];     p3 = [3 3];     ps = [3 1];
tiles = { {p1} {p2} {p3} {p1,p2} {p1,p2,p3} {p1,p2,ps}};
numTiles = numel(tiles);

% save data dirs
testDir = fullfile(DATA_DIR, 'test3');
dirs = cell(numTiles, 1);
for i = 1:numTiles
    dirs{i} = fullfile(testDir, num2str(i));
end

% number of executions
N = 10;

%% precompute histograms

vocabulary = buildVocabulary(classes, 'saveDir', testDir);
for i = 1:numTiles
    dir = dirs{i};
    for class = classes
        classname = char(class);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', 'phow', ...
                        'tiles', tiles{i}, ...
                        'saveDir', dir);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', 'phow', ...
                        'tiles', tiles{i}, ...
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
    for i = 1:numClasses
       classname = char(classes{i});
       results{i} = test.pyramid(classname, dirs, N);
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

% per-class results
figure(1)
fscores = zeros(numClasses, numTiles);
ferr = zeros(numClasses, numTiles);
for i = 1:numClasses
    classname = char(classes{i});
    data = zeros(4, numTiles);
    err = zeros(4, numTiles);
    for j = 1:numTiles
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j) = struct2array(results{i}{j}.std);
        fscores(i,j) = data(4,j);
        ferr(i,j) = err(4,j);
    end
    subplot(2,3,i)
    test.bar(data,err);
    ylim([0 1])
    title(classname, 'Interpreter', 'none')
    legend('1\times1', '2\times2', '3\times3', '1\times1 2\times2', ...
           '1\times1 2\times2 3\times3', '1\times1 2\times2 3\times1')
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test3-all.eps'), '-depsc2', '-f1')

% global
figure(2)
test.bar(fscores,ferr);
ylim([0 1])
title('F-score')
legend('1\times1', '2\times2', '3\times3', '1\times1 2\times2', ...
           '1\times1 2\times2 3\times3', '1\times1 2\times2 3\times1')
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test3-fscore.eps'), '-depsc2', '-f2')

clear i j class classname data
