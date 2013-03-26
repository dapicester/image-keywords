% TEST1_DICTIONARY  Test dictionary for PHOW.
%
%   Objective: check wheter a global dictionary built on all the classes is
%   more powerful than a dictionary built for each class.

clc, clear all
setup

% image classes
classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };

% save data dir
dir_a = fullfile(DATA_DIR, 'test1','a');
dir_b = fullfile(DATA_DIR, 'test1','b');

% number of executions
N = 10;

%% a. precompute per-class dictionary and histograms

for class = classes
    classname = char(class);
    vocabulary = buildVocabulary(classname, 'saveDir', dir_a);
    buildHistograms(classname, vocabulary, 'saveDir', dir_a);
    buildHistograms(classname, vocabulary, 'reject', true, 'saveDir', dir_a);
end
clear class classname vocabulary

%% b. precompute global dictionary and histograms

vocabulary = buildVocabulary(classes, 'saveDir', dir_b);
for class = classes
    classname = char(class);
    buildHistograms(classname, vocabulary, 'saveDir', dir_b);
    buildHistograms(classname, vocabulary, 'reject', true, 'saveDir', dir_b);
end
clear class classname vocabulary

%% load datasets

datasets_a = containers.Map;
datasets_b = containers.Map;
for class = classes
    classname = char(class);
    
    % reset random because we want datasets a and b to use the same images
    rng(0);
    for i = 1:N
        [train(i), val(i)] = loadData(classname, 'datadir', dir_a);
    end
    datasets_a(classname) = struct('train', train, 'val', val);
    
    rng(0);
    for i = 1:N
        [train(i), val(i)] = loadData(classname, 'datadir', dir_b);
    end
    datasets_b(classname) = struct('train', train, 'val', val);
    
    % ensure dataset are equals
    for i = 1:N
        assert(isequal(strcmp(datasets_a(classname).train(i).names, datasets_b(classname).train(i).names), ...
                       true(size(datasets_a(classname).train(i).names))));
        assert(isequal(strcmp(datasets_a(classname).val(i).names, datasets_b(classname).val(i).names), ...
                       true(size(datasets_a(classname).val(i).names))));
    end
end
clear i class classname train val

%% a. per-class dictionary classification

results_a = containers.Map;
for class = classes
    classname = char(class);
    datasets = datasets_a(classname);
    results = cell(N, 1);
    for i = 1:N
        % classify
        fprintf('a. Classifying images in class "%s" (%d/%d)\n', classname, i, N)
        results{i} = classify(datasets.train(i), datasets.val(i), @linearKernel);
    end
    results = struct2dataset(cell2mat(results));
    results_a(classname) = showResults(classname, results, 'summary', false);
%     disp('Press a key to continue with next class, CTRL-C to quit'), pause
end
clear i class classname datasets results 

%% b. global dictionary classification

results_b = containers.Map;
for class = classes
    classname = char(class);
    datasets = datasets_b(classname);
    results = cell(N, 1);
    for i = 1:N
        % classify
        fprintf('b. Classifying images in class "%s" (%d/%d)\n', classname, i, N)
        results{i} = classify(datasets.train(i), datasets.val(i), @linearKernel);
    end
    results = struct2dataset(cell2mat(results));
    results_b(classname) = showResults(classname, results, 'summary', false);
end
clear i class classname datasets results 

%% compare results

% per-class results
figure(1)    
n = 1;
fscores = zeros(numel(classes), 2);
for class = classes
    classname = char(class);
    data = [ struct2array(results_a(classname)); ...
             struct2array(results_b(classname)) ]';
    fscores(n, :) = [results_a(classname).fscore results_b(classname).fscore];
    subplot(2, 3, n)
    bar(data, 'hist')
    title(classname, 'Interpreter', 'none')
    legend('per-class dictionary', 'global dictionary')
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
    n = n+1;
end
    
% only f-score
figure(2)
bar(fscores, 'hist')
title('F-score')
legend('per-class dictionary', 'global dictionary')
set(gca, 'XTickLabel', classes);

clear n class classname data