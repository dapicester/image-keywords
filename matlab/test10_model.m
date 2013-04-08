% TEST10_MODEL  Test SVM model.
%
%   Objective: find the best support vector model for the classification.

% Author: Paolo D'Apice

clc, clear all
setup

% image classes/kernels
%classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };
classes = { 'bag', 'shoes' };
kernels = { @kernel.linear, @kernel.linear };
numClasses = numel(classes);

% save data dirs
testDir = fullfile(DATA_DIR, 'test10');

% number of executions
N = 10;

%% precompute histograms

for class = classes
    classname = char(class);
    buildHistograms(classname, {}, ...
                    'descriptors', 'phog', ...
                    'levels', 1);
    buildHistograms(classname, {}, ...
                    'descriptors', 'phog', ...
                    'levels', 1, ...
                    'reject', true);
end
clear class classname

%% do test

resultsFile = fullfile(testDir, 'results.mat');

if exist(resultsFile, 'file')
    % load results from file
    load(resultsFile);
    fprintf('Results loaded from file %s\n', resultsFile)
else
    % find best parameters
    params = cell(1, numClasses);
    parfor i = 1:numClasses
        params{i} = test.model(char(classes{i}), kernels{i}, DATA_DIR, N);
    end
    save(resultsFile, 'params')
    fprintf('Results saved to file %s\n', resultsFile)
    clear i
end

%% results

filename = fullfile(testDir, 'params.txt');
fid = fopen(filename, 'w');
fprintf(fid, 'class bestnu\n');
for i = 1:numClasses
    fprintf(fid, '%s %g\n', char(classes{i}), params{i}.bestn);
end
fclose(fid);
fprintf(fileread(filename));

clear filename fid i