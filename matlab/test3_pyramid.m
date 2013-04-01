% TEST3_PYRAMID  Test pyramid representation for PHOW.
%
%   Objective: check how the pyramid representation affects the classification.

clc, clear all
setup

% image classes
classes = { 'cellphone', 'face', 'person', 'shoes', 'standing_people' };

% pyramid representations
p1 = [1 1];     p2 = [2 2];     p3 = [4 4];     ps = [3 1];
tiles = { {p1} {p2} {p3} {p1,p2} {p1,p2,p3} {p1,p2,ps}};
numTiles = numel(tiles);

% save data dirs
dirs = cell(numTiles, 1);
for i = 1:numTiles
    dirs{i} = fullfile(DATA_DIR, 'test3', num2str(i));
end

% number of executions
N = 10;

%% precompute histograms

vocabulary = buildVocabulary(classes, 'saveDir', fullfile(DATA_DIR, 'test3'));
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

%% load datasets

datasets = cell(numTiles, 1);
for i = 1:numTiles
    dir = dirs{i};
   
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

results = cell(numTiles, 1);
for i = 1:numTiles
    result = containers.Map;
    for class = classes
        classname = char(class);
        dataset = datasets{i}(classname);
        res = cell(N, 1);
        for j = 1:N
            % classify
            fprintf('%d. Classifying images in class "%s" (%d/%d)\n', i, classname, j, N)
            res{j} = test.classify(dataset.train(j), dataset.val(j));
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
fscores = zeros(numel(classes), numTiles);
for class = classes
    classname = char(class);
    data = zeros(4, numel(numTiles));
    for i = 1:numTiles
        data(:,i) = struct2array(results{i}(classname));
        fscores(n,i) = data(4,1);
    end
    subplot(2,3,n)
    bar(data,'hist')
    ylim([0 1])
    title(classname, 'Interpreter', 'none')
    legend('1\times1', '2\times2', '4\times4', '1\times1 2\times2', ...
           '1\times1 2\times2 4\times4', '1\times1 2\times2 3\times1')
    set(gca, 'XTickLabel', {'accuracy', 'precision', 'recall', 'f-score'})
    n = n+1;
end
set(gcf, 'PaperPositionMode', 'auto')
print('test3-all.eps', '-depsc2', '-f1')

% global
figure(2)
bar(fscores, 'hist')
ylim([0 1])
title('F-score')
legend('1\times1', '2\times2', '4\times4', '1\times1 2\times2', ...
           '1\times1 2\times2 4\times4', '1\times1 2\times2 3\times1')
set(gca, 'XTickLabel', classes);
set(gcf, 'PaperPositionMode', 'auto')
print('test3-fscore.eps', '-depsc2', '-f2')

clear n class classname data
