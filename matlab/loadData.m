function [vocabulary, train, val] = loadData(class)
% LOADDATA  Load training and validation data.
%   [VOCABULARY, TRAIN, VAL] = LOADDATA(CLASS) Load words vocabulary,
%   training and validation data for the given CLASS.

% Author: Paolo D'Apice

global DATA_DIR;

vocabulary = load(fullfile(DATA_DIR, sprintf('vocabulary_%s.mat', class)));

% training data (target class)
pos = load(fullfile(DATA_DIR, sprintf('%s_train_hist.mat', class)));
train.names = pos.names;
train.histograms = double(pos.histograms');
train.labels = ones(size(train.histograms, 1), 1);
fprintf('Number of training images: %d\n', size(train.histograms, 1));
clear pos

% validation data (target and rejection class)
pos = load(fullfile(DATA_DIR, sprintf('%s_val_hist.mat', class)));
neg = load(fullfile(DATA_DIR, sprintf('%s_reject_hist.mat', class)));
val.names = [pos.names; neg.names];
val.histograms = double([pos.histograms neg.histograms]');
val.labels = [ones(numel(pos.names), 1); -ones(numel(neg.names), 1)];
fprintf('Number of validation images: %d positive, %d negative\n', ...
        sum(val.labels > 0), sum(val.labels < 0));
