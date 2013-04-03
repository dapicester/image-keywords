% TEST6_PYRAMID  Test pyramid representation for PHOG.
%
%   Objective: check how the pyramid representation affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes
%classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
classes = { 'bag', 'shoes' };
numClasses = numel(classes);

% pyramid levels
levels = 0:3;
numLevels = numel(levels);

% save data dirs
testDir = fullfile(DATA_DIR, 'test6');
dirs = cell(numLevels, 1);
for i = 1:numLevels
    dirs{i} = fullfile(testDir, num2str(levels(i)));
end

% number of executions
N = 10;

%% precompute histograms

for i = 1:numLevels
    dir = dirs{i};
    for class = classes
        classname = char(class);
        buildHistograms(classname, {}, ...
                        'descriptors', 'phog', ...
                        'levels', levels(i), ...
                        'saveDir', dir);
        buildHistograms(classname, {}, ...
                        'descriptors', 'phog', ...
                        'levels', levels(i), ...
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
fscores = zeros(numClasses, numLevels);
ferr = zeros(numClasses, numLevels);
for i = 1:numClasses
    classname = char(classes{i});
    data = zeros(4, numLevels);
    err = zeros(4, numLevels);
    for j = 1:numLevels
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j) = struct2array(results{i}{j}.std);
        fscores(i,j) = data(4,j);
        ferr(i,j) = err(4,j);
    end
    subplot(2,3,i)
    test.bar(data,err);
    ylim([0 1])
    title(classname, 'Interpreter', 'none')
    legend(num2str(levels'))
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test6-all.eps'), '-depsc2', '-f1')

% global
figure(2)
test.bar(fscores,ferr);
ylim([0 1])
title('F-score')
legend(num2str(levels'))
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test6-fscore.eps'), '-depsc2', '-f2')

clear i j class classname data
