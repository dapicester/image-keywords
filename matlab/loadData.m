% LOADDATA  Load training and validation data.

vocabulary = load('../data/vocabulary_person.mat');

% target class
pos = load('../data/person_train_hist.mat');
names = pos.names;
histograms = double(pos.histograms');
labels = ones(size(histograms, 1), 1);
fprintf('Number of training images: %d\n', size(histograms, 1));
clear pos

% validation data
pos = load('../data/person_val_hist.mat');
neg = load('../data/background_val_hist.mat');
testNames = [pos.names; neg.names];
testHistograms = double([pos.histograms neg.histograms]');
testLabels = [ones(numel(pos.names), 1); -ones(numel(neg.names), 1)];
fprintf('Number of validation images: %d positive, %d negative\n', ...
        sum(testLabels > 0), sum(testLabels < 0));
clear pos neg