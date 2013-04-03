% TEST4_SIFT  Test SIFT parameters
%
%   Objective: check how the SIFT parameters affects the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes
%classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
classes = { 'bag', 'shoes' };
numClasses = numel(classes);

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
    for class = classes
        classname = char(class);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', 'phow', ...
                        'step', params{i}{1}, ...
                        'scales', params{i}{2}, ...
                        'saveDir', dir);
        buildHistograms(classname, vocabulary, ...
                        'descriptors', 'phow', ...
                        'step', params{i}{1}, ...
                        'scales', params{i}{2}, ...
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
       results{i} = test.descriptorsParams(classname, dirs, N);
    end
    save(resultsFile, 'results')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i classname
end

%% compare results

% per-class results
figure(1)
fscores = zeros(numClasses, numParams);
ferr = zeros(numClasses, numParams);
for i = 1:numClasses
    classname = char(classes{i});
    data = zeros(4, numParams);
    err = zeros(4, numParams);
    for j = 1:numParams
        data(:,j) = struct2array(results{i}{j}.mean);
        err(:,j) = struct2array(results{i}{j}.std);
        fscores(i,j) = data(4,j);
        ferr(i,j) = err(4,j);
    end
    subplot(2,3,i)
    test.bar(data,err);
    ylim([0 1])
    title(classname, 'Interpreter', 'none')
    legend(cellfun(@(x) sprintf('s = %d \\sigma = %s\n', x{1}, mat2str(x{2})), ...
                   params, 'UniformOutput', false));
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
end
set(gcf, 'Units', 'Normalized', 'Position', [0 0 1 1], 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test4-all.eps'), '-depsc2', '-f1')

% global
figure(2)
test.bar(fscores,ferr);
ylim([0 1])
title('F-score')
legend(cellfun(@(x) sprintf('s = %d \\sigma = %s\n', x{1}, mat2str(x{2})), ...
               params, 'UniformOutput', false));
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print(fullfile(testDir, 'test4-fscore.eps'), '-depsc2', '-f2')

clear i j class classname data
