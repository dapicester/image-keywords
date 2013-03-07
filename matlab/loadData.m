function [train, val, vocabulary] = loadData(class, varargin)
% LOADDATA  Load training and validation data.
%   [TRAIN, VAL, VOCABULARY] = LOADDATA(CLASS) Load words vocabulary,
%   training and validation data for the given CLASS.
%   
%   Use LOADDATA(..., 'ratio', R) for overriding the default ratio of 0.75
%   (i.e. 75% of target pictures for training and 25% for validation).
%   Use LOADDATA(..., 'outliers', O) for specify the ratio between outliers 
%   and targets in the validation set (by default the number of outliers is
%   equal to the number of targets. i.e. ratio equals to 1).

% Author: Paolo D'Apice

opts.ratio = 0.75;
opts.outliers = 1;
opts = vl_argparse(opts, varargin);

global DATA_DIR;

vocabulary = load(fullfile(DATA_DIR, sprintf('vocabulary_%s.mat', class)));

% load data
data = load(fullfile(DATA_DIR, [class '_hist.mat']));
reject = load(fullfile(DATA_DIR, [class '_reject_hist.mat']));

len = size(data.histograms, 2);
numTargets = round(len * opts.ratio);
numOutliers = round((len - numTargets) * opts.outliers);

indTargets = subset(data.histograms, numTargets);
indOutliers = subset(reject.histograms, numOutliers);

% training data (target class)
train.names = data.names(indTargets);
train.histograms = double(data.histograms(:,indTargets)');
train.labels = ones(numTargets, 1);
fprintf('Number of training images: %d\n', size(train.histograms, 1));

% validation data (target and rejection classes)
val.names = [data.names(~indTargets); reject.names(indOutliers)];
val.histograms = double([data.histograms(:, ~indTargets) reject.histograms(:, indOutliers)]');
val.labels = [ones(len-numTargets, 1); -ones(numOutliers, 1)];
fprintf('Number of validation images: %d positive, %d negative\n', ...
        sum(val.labels > 0), sum(val.labels < 0));
end

function ind = subset(data, len)
% SUBSET  Return a subset of LEN rows of the input DATA.
    n = size(data, 2);
    ind = zeros(1, n);
    ind(sort(randperm(n, len))) = 1;
    ind = logical(ind);
end