% TEST2_DICTIONARY_SIZE  Test dictionary size for PHOW.
%
%   Objective: check how the dictionary size affects the classification.

clc, clear all
setup

% image classes
classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };

% dictionary sizes
dictionarySize = [ 200 300 500 800 1000 2000 ];
numDictionaries = numel(dictionarySize);

% save data dirs
dirs = cell(numDictionaries, 1);
for i = 1:numDictionaries
    dirs{i} = fullfile(DATA_DIR, 'test2', num2str(dictionarySize(i)));
end

% number of executions
N = 10;

%% precompute dictionaries

for i = 1:numDictionaries
    dir = char(dirs{i});
    vocabulary = buildVocabulary(classes, 'numWords', dictionarySize(i), 'saveDir', dir);
    for class = classes
        classname = char(class);
        buildHistograms(classname, vocabulary, 'descriptors', 'phow', 'saveDir', dir);
        buildHistograms(classname, vocabulary, 'descriptors', 'phow', 'reject', true, 'saveDir', dir);
    end
end
clear i dir class classname vocabulary

%% load datasets

datasets = cell(numDictionaries, 1);
for i = 1:numDictionaries
    dir = char(dirs{i});
   
    dataset = containers.Map;
    for class = classes
        classname = char(class);

        % reset random because we want datasets to use the same images
        rng(0);
        for j = 1:N
            [train(j), val(j)] = loadData(classname, 'datadir', dir);
        end
        dataset(classname) = struct('train', train, 'val', val);
    end  
    datasets{i} = dataset;
end
clear i j dir class classname dataset train val

%% run classification

results = cell(numDictionaries, 1);
for i = 1:numDictionaries
    result = containers.Map;
    for class = classes
        classname = char(class);
        dataset = datasets{i}(classname);
        res = cell(N, 1);
        for j = 1:N
            % classify
            fprintf('%d. Classifying images in class "%s" (%d/%d)\n', i, classname, j, N)
            res{j} = classify(dataset.train(j), dataset.val(j), @kernel.linear);
        end
        res = struct2dataset(cell2mat(res));
        result(classname) = showResults(classname, res, 'summary', false);
    end
    results{i} = result;
end
clear i j result class classname dataset res

%% compare results

% per-class results
figure(1)
n = 1;
fscores = zeros(numel(classes), numDictionaries);
for class = classes
    classname = char(class);
    data = zeros(4, numel(classes));
    for i = 1:numDictionaries
        data(:,i) = struct2array(results{i}(classname));
        fscores(n,i) = data(4,1);
    end
    subplot(2,3,n)
    bar(data,'hist')
    title(classname, 'Interpreter', 'none')
    legend({num2str(dictionarySize')})
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
    n = n+1;
end

% global
figure(2)
bar(fscores, 'hist')
title('F-score')
legend({num2str(dictionarySize')})
set(gca, 'XTickLabel', classes);

clear n class classname data